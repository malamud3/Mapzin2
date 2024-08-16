import express from 'express';
import * as poiController from '../controllers/poiController';

const router = express.Router({ mergeParams: true });

router.post('/', poiController.addPOI);
router.get('/:poiId', poiController.getPOI);
router.put('/:poiId', poiController.updatePOI);
router.delete('/:poiId', poiController.deletePOI);

export default router;
