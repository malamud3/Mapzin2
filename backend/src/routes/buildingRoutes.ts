import express from 'express';
import * as buildingController from '../controllers/buildingController';

const router = express.Router();

router.post('/', buildingController.createBuilding);
router.get('/', buildingController.getAllBuildings);
router.get('/:id', buildingController.getBuildingById);
router.put('/:id', buildingController.updateBuilding);
router.delete('/:id', buildingController.deleteBuilding);

export default router;
