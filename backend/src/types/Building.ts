// src/types/Building.ts

export interface Building {
    _id?: string;
    name: string;
    address: string;
    location: {
        longitude: string;
        latitude: string;
    };
    floors: Floor[];
}

interface Floor {
    level: number;
    name: string;
    pois: POI[];
}

interface POI {
    name: string;
    type: string;
    location: {
        x: number;
        y: number;
    };
    description: string;
    connections: Connection[];
}

interface Connection {
    connectedPoiId: string;
    distance: number;
}

export function isValidBuilding(data: any): data is Building {
    return (
        typeof data === 'object' &&
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
