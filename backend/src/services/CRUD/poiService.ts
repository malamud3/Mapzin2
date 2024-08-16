import { ObjectId } from 'mongodb';
import { getDb } from '../../config/database';
import { POI } from '../../entities/POI';
import { BuildingDocument } from '../../entities/Building';

export const addPOI = async (buildingId: string, floorId: string, poiData: POI): Promise<POI> => {
    const db = getDb();
    const poiWithId = { ...poiData, _id: new ObjectId() };
    const result = await db.collection<BuildingDocument>('buildings').findOneAndUpdate(
        { _id: new ObjectId(buildingId), 'floors._id': new ObjectId(floorId) },
        { $push: { 'floors.$.pois': poiWithId } },
        { returnDocument: 'after' }
    );
    if (!result) {
        throw new Error('Building or floor not found');
    }
    const addedPOI = result.floors.find(f => f._id && f._id.toString() === floorId)?.pois.slice(-1)[0];
    if (!addedPOI) {
        throw new Error('Failed to add POI');
    }
    return addedPOI;
};

export const getPOI = async (buildingId: string, floorId: string, poiId: string): Promise<POI | null> => {
    const db = getDb();
    const result = await db.collection<BuildingDocument>('buildings').findOne(
        { _id: new ObjectId(buildingId), 'floors._id': new ObjectId(floorId), 'floors.pois._id': new ObjectId(poiId) },
        { projection: { 'floors.$': 1 } }
    );
    if (!result || !result.floors[0]) return null;
    return result.floors[0].pois.find(poi => poi._id && poi._id.toString() === poiId) || null;
};

export const updatePOI = async (buildingId: string, floorId: string, poiId: string, poiData: POI): Promise<boolean> => {
    const db = getDb();
    const result = await db.collection<BuildingDocument>('buildings').updateOne(
        { _id: new ObjectId(buildingId), 'floors._id': new ObjectId(floorId), 'floors.pois._id': new ObjectId(poiId) },
        { $set: { 'floors.$[floor].pois.$[poi]': { ...poiData, _id: new ObjectId(poiId) } } },
        { arrayFilters: [{ 'floor._id': new ObjectId(floorId) }, { 'poi._id': new ObjectId(poiId) }] }
    );
    return result.modifiedCount > 0;
};

export const deletePOI = async (buildingId: string, floorId: string, poiId: string): Promise<boolean> => {
    const db = getDb();
    const result = await db.collection<BuildingDocument>('buildings').updateOne(
        { _id: new ObjectId(buildingId), 'floors._id': new ObjectId(floorId) },
        { $pull: { 'floors.$.pois': { _id: new ObjectId(poiId) } } }
    );
    return result.modifiedCount > 0;
};
