// src/models/Connection.ts

export interface Connection {
    connectedPoiId: string;
    distance: number;
}

export function isValidConnection(data: any): data is Connection {
    return (
        typeof data === 'object' &&
        typeof data.connectedPoiId === 'string' &&
        typeof data.distance === 'number' &&
        !isNaN(data.distance) &&
        data.distance >= 0
    );
}
