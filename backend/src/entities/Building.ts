// src/types/Building.ts
import { ObjectId } from 'mongodb';
import {Floor, FloorDocument, fromFloorDocument, toFloorDocument} from "./Floor";

export interface Building {
    _id?: string | ObjectId;
    name: string;
    address: string;
    location: {
        longitude: string;
        latitude: string;
    };
    floors: Floor[];
}

export interface BuildingDocument extends Omit<Building, '_id' | 'floors'> {
    _id?: ObjectId;
    floors: FloorDocument[];
}

export function toBuildingDocument(building: Building): BuildingDocument {
    const { _id, floors, ...rest } = building;
    return {
        ...rest,
        _id: _id instanceof ObjectId ? _id : _id ? new ObjectId(_id) : undefined,
        floors: floors.map(floor => toFloorDocument(floor))
    };
}

export function fromBuildingDocument(doc: BuildingDocument): Building {
    return {
        ...doc,
        _id: doc._id ? doc._id.toString() : undefined,
        floors: doc.floors.map(floor => fromFloorDocument(floor))
    };
}

export function isValidBuilding(data: any): data is Building {
    return (
        typeof data === 'object' &&
        (data._id === undefined || typeof data._id === 'string' || data._id instanceof ObjectId) &&
        typeof data.name === 'string' &&
        typeof data.address === 'string' &&
        typeof data.location === 'object' &&
        typeof data.location.longitude === 'string' &&
        typeof data.location.latitude === 'string' &&
        Array.isArray(data.floors) &&
        data.floors.every((floor: any) =>
            typeof floor === 'object' &&
            typeof floor.level === 'number' &&
            typeof floor.name === 'string' &&
            Array.isArray(floor.pois) &&
            floor.pois.every((poi: any) =>
                typeof poi === 'object' &&
                typeof poi.name === 'string' &&
                typeof poi.type === 'string' &&
                typeof poi.location === 'object' &&
                typeof poi.location.x === 'number' &&
                typeof poi.location.y === 'number' &&
                typeof poi.description === 'string' &&
                Array.isArray(poi.connections) &&
                poi.connections.every((connection: any) =>
                    typeof connection === 'object' &&
                    typeof connection.connectedPoiId === 'string' &&
                    typeof connection.distance === 'number'
                )
            )
        )
    );
}
