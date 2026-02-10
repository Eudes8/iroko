import { Response } from 'express';
import { prisma } from '../server';
import { AuthRequest } from '../middleware/auth';

export const paymentController = {
  // CREATE PAYMENT / ESCROW
  createPayment: async (req: AuthRequest, res: Response) => {
    try {
      const { missionId, amount, paymentMethod } = req.body;
      const clientId = req.user?.id;

      if (!missionId || !amount || !paymentMethod) {
        return res.status(400).json({
          success: false,
          error: 'Missing required fields',
        });
      }

      if (amount <= 0) {
        return res.status(400).json({
          success: false,
          error: 'Amount must be greater than 0',
        });
      }

      const mission = await prisma.mission.findUnique({
        where: { id: missionId },
      });

      if (!mission) {
        return res.status(404).json({
          success: false,
          error: 'Mission not found',
        });
      }

      if (mission.clientId !== clientId) {
        return res.status(403).json({
          success: false,
          error: 'Not authorized',
        });
      }

      if (!mission.providerId) {
        return res.status(400).json({
          success: false,
          error: 'Mission must be accepted first',
        });
      }

      const commission = amount * 0.1; // 10% commission
      const providerEarnings = amount * 0.9;

      const payment = await prisma.payment.create({
        data: {
          missionId,
          clientId: clientId!,
          providerId: mission.providerId,
          amount,
          commission,
          providerEarnings,
          paymentMethod: paymentMethod.toUpperCase(),
        },
      });

      // Update mission payment status
      await prisma.mission.update({
        where: { id: missionId },
        data: { paymentStatus: 'PROCESSING' },
      });

      return res.status(201).json({
        success: true,
        message: 'Payment initiated',
        data: { payment },
      });
    } catch (error) {
      console.error('Create payment error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to create payment',
      });
    }
  },

  // GET PAYMENT
  getPayment: async (req: AuthRequest, res: Response) => {
    try {
      const { paymentId } = req.params;

      const payment = await prisma.payment.findUnique({
        where: { id: paymentId },
        include: {
          mission: true,
          client: { select: { id: true, name: true, email: true } },
          provider: { select: { id: true, name: true, email: true } },
        },
      });

      if (!payment) {
        return res.status(404).json({
          success: false,
          error: 'Payment not found',
        });
      }

      return res.status(200).json({
        success: true,
        data: { payment },
      });
    } catch (error) {
      console.error('Get payment error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to get payment',
      });
    }
  },

  // RELEASE ESCROW
  releaseEscrow: async (req: AuthRequest, res: Response) => {
    try {
      const { paymentId } = req.params;
      const userId = req.user?.id;

      const payment = await prisma.payment.findUnique({
        where: { id: paymentId },
        include: { mission: true },
      });

      if (!payment) {
        return res.status(404).json({
          success: false,
          error: 'Payment not found',
        });
      }

      if (payment.clientId !== userId) {
        return res.status(403).json({
          success: false,
          error: 'Only client can release escrow',
        });
      }

      if (payment.escrowStatus !== 'HELD') {
        return res.status(400).json({
          success: false,
          error: 'Escrow already processed',
        });
      }

      if (payment.mission.status !== 'COMPLETED') {
        return res.status(400).json({
          success: false,
          error: 'Mission must be completed first',
        });
      }

      // Release payment
      const updated = await prisma.payment.update({
        where: { id: paymentId },
        data: {
          escrowStatus: 'RELEASED',
          status: 'RELEASED',
          completedAt: new Date(),
        },
      });

      // Create wallet transaction for provider
      await prisma.walletTransaction.create({
        data: {
          userId: payment.providerId,
          paymentId,
          missionId: payment.missionId,
          type: 'CREDIT',
          amount: payment.providerEarnings,
          description: `Payment for mission: ${payment.mission.title}`,
        },
      });

      return res.status(200).json({
        success: true,
        message: 'Escrow released',
        data: { payment: updated },
      });
    } catch (error) {
      console.error('Release escrow error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to release escrow',
      });
    }
  },

  // GET WALLET BALANCE
  getWalletBalance: async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user?.id;

      const transactions = await prisma.walletTransaction.findMany({
        where: { userId },
        orderBy: { createdAt: 'desc' },
      });

      const balance = transactions.reduce((sum: number, t: any) => {
        return t.type === 'CREDIT' ? sum + t.amount : sum - t.amount;
      }, 0);

      return res.status(200).json({
        success: true,
        data: {
          userId,
          balance,
          transactions,
        },
      });
    } catch (error) {
      console.error('Get wallet balance error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to get wallet balance',
      });
    }
  },
};
