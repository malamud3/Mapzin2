import { ObjectId } from 'mongodb';
import { getDb } from '../../config/database';
import { Floor, FloorDocument, toFloorDocument, fromFloorDocument } from '../../entities/Floor';
import { BuildingDocument } from '../../entities/Building';

export const addFloor = async (buildingId: string, floorData: Omit<Floor, '_id'>): Promise<Floor> => {
    const db = getDb();
    const floorDoc: FloorDocument = { ...floorData, _id: new ObjectId() };
    const result = await db.collection<BuildingDocument>('buildings').findOneAndUpdate(
        { _id: new ObjectId(buildingId) },
        { $push: { floors: floorDoc } },
        { returnDocument: 'after' }
    );
    if (!result) {
        throw new Error('Building not found');
    }
    const addedFloor = result.floors[result.floors.length - 1];
    return fromFloorDocument(addedFloor);
};

export const getFloor = async (buildingId: string, floorId: string): Promise<Floor | null> => {
    const db = getDb();
    const result = await db.collection<BuildingDocument>('buildings').findOne(
        { _id: new ObjectId(buildingId), 'floors._id': new ObjectId(floorId) },
        { projection: { 'floors.$': 1 } }
    );
    return result && result.floors[0] ? fromFloorDocument(result.floors[0]) : null;
};

export const updateFloor = async (buildingId: string, floorId: string, floorData: Omit<Floor, '_id'>): Promise<boolean> => {
    const db = getDb();
    const result = await db.collection<BuildingDocument>('buildings').updateOne(
        { _id: new ObjectId(buildingId), 'floors._id': new ObjectId(floorId) },
        { $set: { 'floors.$': { ...floorData, _id: new ObjectId(floorId) } } }
    );
    return result.modifiedCount > 0;
};

export const deleteFloor = async (buildingId: string, floorId: string): Promise<boolean> => {
    const db = getDb();
    const result = await db.collection<BuildingDocument>('buildings').updateOne(
        { _id: new ObjectId(buildingId) },
        { $pull: { floors: { _id: new ObjectId(floorId) } } }
    );
    return result.modifiedCount > 0;
};
