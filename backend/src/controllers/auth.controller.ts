import { Response } from 'express';
import { prisma } from '../server';
import { AuthRequest } from '../middleware/auth';
import { hashPassword, comparePassword, generateToken, validateEmail } from '../utils/helpers';

export const authController = {
  // SIGN UP
  signup: async (req: AuthRequest, res: Response) => {
    try {
      const { email, password, name, role, phone } = req.body;

      // Validation
      if (!email || !password || !name || !role) {
        return res.status(400).json({
          success: false,
          error: 'Missing required fields',
        });
      }

      if (!validateEmail(email)) {
        return res.status(400).json({
          success: false,
          error: 'Invalid email format',
        });
      }

      if (password.length < 6) {
        return res.status(400).json({
          success: false,
          error: 'Password must be at least 6 characters',
        });
      }

      // Check if user exists
      const existingUser = await prisma.user.findUnique({
        where: { email },
      });

      if (existingUser) {
        return res.status(409).json({
          success: false,
          error: 'Email already registered',
        });
      }

      // Hash password
      const hashedPassword = await hashPassword(password);

      // Create user
      const user = await prisma.user.create({
        data: {
          email,
          password: hashedPassword,
          name,
          role: role.toUpperCase(),
          phone: phone || null,
        },
      });

      // Generate token
      const token = generateToken(user.id, user.email, user.role);

      return res.status(201).json({
        success: true,
        message: 'User created successfully',
        data: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
          },
          token,
        },
      });
    } catch (error) {
      console.error('Signup error:', error);
      return res.status(500).json({
        success: false,
        error: 'Signup failed',
      });
    }
  },

  // LOGIN
  login: async (req: AuthRequest, res: Response) => {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return res.status(400).json({
          success: false,
          error: 'Email and password required',
        });
      }

      // Find user
      const user = await prisma.user.findUnique({
        where: { email },
      });

      if (!user) {
        return res.status(401).json({
          success: false,
          error: 'Invalid email or password',
        });
      }

      // Check password
      const passwordMatch = await comparePassword(password, user.password);

      if (!passwordMatch) {
        return res.status(401).json({
          success: false,
          error: 'Invalid email or password',
        });
      }

      // Generate token
      const token = generateToken(user.id, user.email, user.role);

      return res.status(200).json({
        success: true,
        message: 'Login successful',
        data: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            profileImage: user.profileImage,
            isVerified: user.isVerified,
          },
          token,
        },
      });
    } catch (error) {
      console.error('Login error:', error);
      return res.status(500).json({
        success: false,
        error: 'Login failed',
      });
    }
  },

  // VERIFY TOKEN
  verifyToken: async (req: AuthRequest, res: Response) => {
    try {
      if (!req.user) {
        return res.status(401).json({
          success: false,
          error: 'Not authenticated',
        });
      }

      const user = await prisma.user.findUnique({
        where: { id: req.user.id },
        select: {
          id: true,
          email: true,
          name: true,
          role: true,
          profileImage: true,
          isVerified: true,
          averageRating: true,
          reviewCount: true,
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
      console.error('Verify token error:', error);
      return res.status(500).json({
        success: false,
        error: 'Token verification failed',
      });
    }
  },
};
