import { ObjectId } from 'mongodb';
import { Building, BuildingDocument, isValidBuilding, toBuildingDocument, fromBuildingDocument } from '../../entities/Building';
import { getDb } from '../../config/database';

export const createBuilding = async (buildingData: Omit<Building, '_id'>): Promise<Building> => {
    if (!isValidBuilding(buildingData)) {
        throw new Error('Invalid building data');
    }
    const db = getDb();
    const buildingDoc = toBuildingDocument(buildingData as Building);
    const result = await db.collection<BuildingDocument>('buildings').insertOne(buildingDoc);
    return fromBuildingDocument({ ...buildingDoc, _id: result.insertedId });
};

export const getAllBuildings = async (): Promise<Building[]> => {
    const db = getDb();
    const documents = await db.collection<BuildingDocument>('buildings').find().toArray();
    return documents.map(fromBuildingDocument);
};

export const getBuildingById = async (id: string): Promise<Building | null> => {
    const db = getDb();
    const document = await db.collection<BuildingDocument>('buildings').findOne({ _id: new ObjectId(id) });
    return document ? fromBuildingDocument(document) : null;
};

export const updateBuilding = async (id: string, buildingData: Omit<Building, '_id'>): Promise<boolean> => {
    if (!isValidBuilding(buildingData)) {
        throw new Error('Invalid building data');
    }
    const db = getDb();
    const buildingDoc = toBuildingDocument({ ...buildingData, _id: id });
    const result = await db.collection<BuildingDocument>('buildings').updateOne(
        { _id: new ObjectId(id) },
        { $set: buildingDoc }
    );
    return result.matchedCount > 0;
};

export const deleteBuilding = async (id: string): Promise<boolean> => {
    const db = getDb();
    const result = await db.collection<BuildingDocument>('buildings').deleteOne({ _id: new ObjectId(id) });
    return result.deletedCount > 0;
};
