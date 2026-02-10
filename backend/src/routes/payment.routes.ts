import express from 'express';
import { paymentController } from '../controllers/payment.controller';
import { authenticate } from '../middleware/auth';

const router = express.Router();

router.post('/create', authenticate, paymentController.createPayment);
router.get('/:paymentId', paymentController.getPayment);
router.post('/:paymentId/release', authenticate, paymentController.releaseEscrow);
router.get('/wallet/balance', authenticate, paymentController.getWalletBalance);

export default router;
