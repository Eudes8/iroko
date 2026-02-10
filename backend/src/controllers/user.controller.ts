import { Response } from 'express';
import { prisma } from '../server';
import { AuthRequest } from '../middleware/auth';

export const userController = {
  // GET PROFILE
  getProfile: async (req: AuthRequest, res: Response) => {
    try {
      const { userId } = req.params;

      const user = await prisma.user.findUnique({
        where: { id: userId },
        select: {
          id: true,
          email: true,
          name: true,
          phone: true,
          profileImage: true,
          role: true,
          bio: true,
          isVerified: true,
          averageRating: true,
          reviewCount: true,
          specialties: true,
          hourlyRate: true,
          location: true,
          createdAt: true,
        },
      });

      if (!user) {
        return res.status(404).json({
          success: false,
          error: 'User not found',
        });
      }

      return res.status(200).json({
        success: true,
        data: { user },
      });
    } catch (error) {
      console.error('Get profile error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to get profile',
      });
    }
  },

  // UPDATE PROFILE
  updateProfile: async (req: AuthRequest, res: Response) => {
    try {
      const { userId } = req.params;
      const { name, phone, bio, profileImage, specialties, hourlyRate, location } = req.body;
      const requesterId = req.user?.id;

      if (userId !== requesterId) {
        return res.status(403).json({
          success: false,
          error: 'Not authorized',
        });
      }

      const updated = await prisma.user.update({
        where: { id: userId },
        data: {
          name: name || undefined,
          phone: phone || undefined,
          bio: bio || undefined,
          profileImage: profileImage || undefined,
          specialties: specialties || undefined,
          hourlyRate: hourlyRate || undefined,
          location: location || undefined,
        },
        select: {
          id: true,
          email: true,
          name: true,
          phone: true,
          profileImage: true,
          role: true,
          bio: true,
          isVerified: true,
          averageRating: true,
        },
      });

      return res.status(200).json({
        success: true,
        message: 'Profile updated',
        data: { user: updated },
      });
    } catch (error) {
      console.error('Update profile error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to update profile',
      });
    }
  },

  // LIST PROVIDERS
  listProviders: async (req: AuthRequest, res: Response) => {
    try {
      const { specialty, minRating = '0', limit = '20', offset = '0' } = req.query;

      const where: any = {
        role: 'PROVIDER',
        isVerified: true,
      };

      if (minRating) {
        where.averageRating = { gte: parseFloat(minRating as string) };
      }

      let providers = await prisma.user.findMany({
        where,
        select: {
          id: true,
          name: true,
          email: true,
          profileImage: true,
          bio: true,
          averageRating: true,
          reviewCount: true,
          specialties: true,
          hourlyRate: true,
          location: true,
        },
        skip: parseInt(offset as string),
        take: parseInt(limit as string),
        orderBy: { averageRating: 'desc' },
      });

      // Filter by specialty on client side if needed
      if (specialty) {
        providers = providers.filter((p: any) =>
          p.specialties?.includes(specialty)
        );
      }

      const total = await prisma.user.count({ where });

      return res.status(200).json({
        success: true,
        data: {
          providers,
          total,
          limit: parseInt(limit as string),
          offset: parseInt(offset as string),
        },
      });
    } catch (error) {
      console.error('List providers error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to list providers',
      });
    }
  },

  // RATE USER
  rateUser: async (req: AuthRequest, res: Response) => {
    try {
      const { userId } = req.params;
      const { rating, review } = req.body;
      const ratedBy = req.user?.id;

      if (!rating || rating < 1 || rating > 5) {
        return res.status(400).json({
          success: false,
          error: 'Rating must be between 1 and 5',
        });
      }

      // Create or update rating
      const ratingRecord = await prisma.rating.upsert({
        where: {
          userId_ratedBy: {
            userId,
            ratedBy: ratedBy!,
          },
        },
        update: {
          rating,
          review: review || null,
        },
        create: {
          userId,
          ratedBy: ratedBy!,
          rating,
          review: review || null,
        },
      });

      // Recalculate average rating
      const ratings = await prisma.rating.findMany({
        where: { userId },
      });

      const avgRating = ratings.reduce((sum: number, r: any) => sum + r.rating, 0) / ratings.length;

      await prisma.user.update({
        where: { id: userId },
        data: {
          averageRating: avgRating,
          reviewCount: ratings.length,
        },
      });

      return res.status(201).json({
        success: true,
        message: 'Rating added',
        data: { rating: ratingRecord },
      });
    } catch (error) {
      console.error('Rate user error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to rate user',
      });
    }
  },
};
