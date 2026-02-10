import express from 'express';
import { userController } from '../controllers/user.controller';
import { authenticate } from '../middleware/auth';

const router = express.Router();

router.get('/:userId', userController.getProfile);
router.patch('/:userId', authenticate, userController.updateProfile);
router.get('/', userController.listProviders);
router.post('/:userId/rate', authenticate, userController.rateUser);

export default router;
