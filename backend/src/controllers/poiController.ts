import { Request, Response } from 'express';
import * as poiService from '../services/CRUD/poiService';

export const addPOI = async (req: Request, res: Response): Promise<void> => {
    try {
        const { buildingId, floorId } = req.params;
        const poi = await poiService.addPOI(buildingId, floorId, req.body);
        res.status(201).json(poi);
    } catch (error) {
        res.status(500).json({ message: 'Error adding POI', error: (error as Error).message });
    }
};

export const getPOI = async (req: Request, res: Response): Promise<void> => {
    try {
        const { buildingId, floorId, poiId } = req.params;
        const poi = await poiService.getPOI(buildingId, floorId, poiId);
        if (poi) {
            res.json(poi);
        } else {
            res.status(404).json({ message: 'POI not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error fetching POI', error: (error as Error).message });
    }
};

export const updatePOI = async (req: Request, res: Response): Promise<void> => {
    try {
        const { buildingId, floorId, poiId } = req.params;
        const updated = await poiService.updatePOI(buildingId, floorId, poiId, req.body);
        if (updated) {
            res.json({ message: 'POI updated successfully' });
        } else {
            res.status(404).json({ message: 'POI not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error updating POI', error: (error as Error).message });
    }
};

export const deletePOI = async (req: Request, res: Response): Promise<void> => {
    try {
        const { buildingId, floorId, poiId } = req.params;
        const deleted = await poiService.deletePOI(buildingId, floorId, poiId);
        if (deleted) {
            res.json({ message: 'POI deleted successfully' });
        } else {
            res.status(404).json({ message: 'POI not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error deleting POI', error: (error as Error).message });
    }
};
