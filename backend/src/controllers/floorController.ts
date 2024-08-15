import { Request, Response } from 'express';
import * as floorService from '../services/CRUD/floorService';

export const addFloor = async (req: Request, res: Response): Promise<void> => {
    try {
        const { buildingId } = req.params;
        const floor = await floorService.addFloor(buildingId, req.body);
        res.status(201).json(floor);
    } catch (error) {
        res.status(500).json({ message: 'Error adding floor', error: (error as Error).message });
    }
};

export const getFloor = async (req: Request, res: Response): Promise<void> => {
    try {
        const { buildingId, floorId } = req.params;
        const floor = await floorService.getFloor(buildingId, floorId);
        if (floor) {
            res.json(floor);
        } else {
            res.status(404).json({ message: 'Floor not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error fetching floor', error: (error as Error).message });
    }
};

export const updateFloor = async (req: Request, res: Response): Promise<void> => {
    try {
        const { buildingId, floorId } = req.params;
        const updated = await floorService.updateFloor(buildingId, floorId, req.body);
        if (updated) {
            res.json({ message: 'Floor updated successfully' });
        } else {
            res.status(404).json({ message: 'Floor not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error updating floor', error: (error as Error).message });
    }
};

export const deleteFloor = async (req: Request, res: Response): Promise<void> => {
    try {
        const { buildingId, floorId } = req.params;
        const deleted = await floorService.deleteFloor(buildingId, floorId);
        if (deleted) {
            res.json({ message: 'Floor deleted successfully' });
        } else {
            res.status(404).json({ message: 'Floor not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error deleting floor', error: (error as Error).message });
    }
};
