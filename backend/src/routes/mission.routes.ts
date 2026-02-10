import express from 'express';
import { missionController } from '../controllers/mission.controller';
import { authenticate } from '../middleware/auth';

const router = express.Router();

router.post('/create', authenticate, missionController.create);
router.get('/:missionId', missionController.getById);
router.get('/', missionController.list);
router.post('/:missionId/accept', authenticate, missionController.accept);
router.post('/:missionId/complete', authenticate, missionController.complete);

export default router;
