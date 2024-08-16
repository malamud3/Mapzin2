import { ObjectId } from 'mongodb';
import {POI} from "./POI";

export interface Floor {
    _id?: string | ObjectId;
    level: number;
    name: string;
    pois: POI[];
}
export function toFloorDocument(floor: Floor): FloorDocument {
    const { _id, ...rest } = floor;
    return {
        ...rest,
        _id: _id instanceof ObjectId ? _id : _id ? new ObjectId(_id) : undefined
    };
}
export interface FloorDocument extends Omit<Floor, '_id'> {
    _id?: ObjectId;
}
export function fromFloorDocument(doc: FloorDocument): Floor {
    return {
        ...doc,
        _id: doc._id ? doc._id.toString() : undefined
    };
}

export function isValidFloor(data: any): data is Floor {
    return (
        typeof data === 'object' &&
        (data._id === undefined || typeof data._id === 'string' || data._id instanceof ObjectId) &&
        typeof data.level === 'number' &&
        typeof data.name === 'string' &&
        Array.isArray(data.pois)
        // You may want to add more specific checks for the POIs array here
    );
}
