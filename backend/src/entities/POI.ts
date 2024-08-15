import {Connection, isValidConnection} from './Connection';
import {ObjectId} from "mongodb";

export interface POI {
    _id?: string | ObjectId;
    name: string;
    type: string;
    location: {
        x: number;
        y: number;
        z: number;
    };
    floor: number;
    description: string;
    connections: Connection[];
}

export function isValidPOI(data: any): data is POI {
    return (
        typeof data === 'object' &&
        typeof data.name === 'string' &&
        typeof data.type === 'string' &&
        typeof data.location === 'object' &&
        typeof data.location.x === 'number' &&
        typeof data.location.y === 'number' &&
        typeof data.description === 'string' &&
        Array.isArray(data.connections) &&
        data.connections.every((connection: any) => isValidConnection(connection))
    );
}
