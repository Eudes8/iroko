import express from 'express';
import { authController } from '../controllers/auth.controller';
import { authenticate } from '../middleware/auth';

const router = express.Router();

router.post('/sign-up', authController.signup);
router.post('/login', authController.login);
router.post('/verify-token', authenticate, authController.verifyToken);

export default router;
