import { Request, Response } from 'express';
import * as buildingService from '../services/CRUD/buildingService';

export const createBuilding = async (req: Request, res: Response): Promise<void> => {
    try {
        const building = await buildingService.createBuilding(req.body);
        res.status(201).json(building);
    } catch (error) {
        res.status(500).json({ message: 'Error creating building', error: (error as Error).message });
    }
};

export const getAllBuildings = async (req: Request, res: Response): Promise<void> => {
    try {
        const buildings = await buildingService.getAllBuildings();
        res.json(buildings);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching buildings', error: (error as Error).message });
    }
};

export const getBuildingById = async (req: Request, res: Response): Promise<void> => {
    try {
        const building = await buildingService.getBuildingById(req.params.id);
        if (building) {
            res.json(building);
        } else {
            res.status(404).json({ message: 'Building not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error fetching building', error: (error as Error).message });
    }
};

export const updateBuilding = async (req: Request, res: Response): Promise<void> => {
    try {
        const updated = await buildingService.updateBuilding(req.params.id, req.body);
        if (updated) {
            res.json({ message: 'Building updated successfully' });
        } else {
            res.status(404).json({ message: 'Building not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error updating building', error: (error as Error).message });
    }
};

export const deleteBuilding = async (req: Request, res: Response): Promise<void> => {
    try {
        const deleted = await buildingService.deleteBuilding(req.params.id);
        if (deleted) {
            res.json({ message: 'Building deleted successfully' });
        } else {
            res.status(404).json({ message: 'Building not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error deleting building', error: (error as Error).message });
    }
};
