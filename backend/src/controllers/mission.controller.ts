import { Response } from 'express';
import { prisma } from '../server';
import { AuthRequest } from '../middleware/auth';

export const missionController = {
  // CREATE MISSION
  create: async (req: AuthRequest, res: Response) => {
    try {
      const { serviceType, title, description, category, level, scheduledDate, durationMinutes, price } = req.body;
      const clientId = req.user?.id;

      if (!serviceType || !title || !description || !scheduledDate || !durationMinutes || price === undefined) {
        return res.status(400).json({
          success: false,
          error: 'Missing required fields',
        });
      }

      const mission = await prisma.mission.create({
        data: {
          clientId: clientId!,
          serviceType: serviceType.toUpperCase(),
          title,
          description,
          category: category || null,
          level: level || null,
          scheduledDate: new Date(scheduledDate),
          durationMinutes,
          price,
          commission: price * 0.1, // 10% commission
        },
      });

      return res.status(201).json({
        success: true,
        message: 'Mission created successfully',
        data: { mission },
      });
    } catch (error) {
      console.error('Create mission error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to create mission',
      });
    }
  },

  // GET MISSION BY ID
  getById: async (req: AuthRequest, res: Response) => {
    try {
      const { missionId } = req.params;

      const mission = await prisma.mission.findUnique({
        where: { id: missionId },
        include: {
          client: {
            select: { id: true, name: true, email: true, profileImage: true, averageRating: true },
          },
          provider: {
            select: { id: true, name: true, email: true, profileImage: true, averageRating: true },
          },
        },
      });

      if (!mission) {
        return res.status(404).json({
          success: false,
          error: 'Mission not found',
        });
      }

      return res.status(200).json({
        success: true,
        data: { mission },
      });
    } catch (error) {
      console.error('Get mission error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to get mission',
      });
    }
  },

  // LIST MISSIONS
  list: async (req: AuthRequest, res: Response) => {
    try {
      const { serviceType, status, clientId, providerId, limit = '20', offset = '0' } = req.query;

      const where: any = {};
      if (serviceType) where.serviceType = (serviceType as string).toUpperCase();
      if (status) where.status = status;
      if (clientId) where.clientId = clientId;
      if (providerId) where.providerId = providerId;

      const [missions, total] = await Promise.all([
        prisma.mission.findMany({
          where,
          skip: parseInt(offset as string),
          take: parseInt(limit as string),
          include: {
            client: { select: { id: true, name: true, profileImage: true } },
            provider: { select: { id: true, name: true, profileImage: true } },
          },
          orderBy: { createdAt: 'desc' },
        }),
        prisma.mission.count({ where }),
      ]);

      return res.status(200).json({
        success: true,
        data: {
          missions,
          total,
          limit: parseInt(limit as string),
          offset: parseInt(offset as string),
        },
      });
    } catch (error) {
      console.error('List missions error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to list missions',
      });
    }
  },

  // ACCEPT MISSION
  accept: async (req: AuthRequest, res: Response) => {
    try {
      const { missionId } = req.params;
      const providerId = req.user?.id;

      const mission = await prisma.mission.findUnique({
        where: { id: missionId },
      });

      if (!mission) {
        return res.status(404).json({
          success: false,
          error: 'Mission not found',
        });
      }

      if (mission.status !== 'PENDING') {
        return res.status(400).json({
          success: false,
          error: 'Mission is not available',
        });
      }

      const updated = await prisma.mission.update({
        where: { id: missionId },
        data: {
          providerId: providerId!,
          status: 'ACCEPTED',
        },
      });

      return res.status(200).json({
        success: true,
        message: 'Mission accepted',
        data: { mission: updated },
      });
    } catch (error) {
      console.error('Accept mission error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to accept mission',
      });
    }
  },

  // COMPLETE MISSION
  complete: async (req: AuthRequest, res: Response) => {
    try {
      const { missionId } = req.params;
      const userId = req.user?.id;

      const mission = await prisma.mission.findUnique({
        where: { id: missionId },
      });

      if (!mission) {
        return res.status(404).json({
          success: false,
          error: 'Mission not found',
        });
      }

      if (mission.providerId !== userId) {
        return res.status(403).json({
          success: false,
          error: 'Not authorized',
        });
      }

      const updated = await prisma.mission.update({
        where: { id: missionId },
        data: {
          status: 'COMPLETED',
          completedAt: new Date(),
        },
      });

      return res.status(200).json({
        success: true,
        message: 'Mission completed',
        data: { mission: updated },
      });
    } catch (error) {
      console.error('Complete mission error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to complete mission',
      });
    }
  },
};
