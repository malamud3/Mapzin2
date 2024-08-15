import express from 'express';
import * as floorController from '../controllers/floorController';

const router = express.Router({ mergeParams: true });

router.post('/', floorController.addFloor);
router.get('/:floorId', floorController.getFloor);
router.put('/:floorId', floorController.updateFloor);
router.delete('/:floorId', floorController.deleteFloor);

export default router;
