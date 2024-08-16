import { ObjectId } from 'mongodb';
import { POI } from "../entities/POI";
import { aStar } from "../services/aStar"; // Import the aStar function

describe('A* Algorithm Tests', () => {
    // Helper function to create a POI
    function createPOI(id: string, name: string, x: number, y: number, connections: {connectedPoiId: string, distance: number}[] = []): POI {
        return {
            _id: new ObjectId(id),
            name,
            type: "TestPOI", // Add a type
            location: { x, y, z: 0 }, // Add z coordinate
            floor: 1, // Add floor
            description: `Test POI: ${name}`, // Add description
            connections
        };
    }

    test('Simple path with two points', () => {
        const pois = [
            createPOI('1', 'Start', 0, 0, [{connectedPoiId: '2', distance: 5}]),
            createPOI('2', 'End', 3, 4)
        ];
        const path = aStar(pois, pois[0], pois[1]);
        expect(path.map(p => p.name)).toEqual(['Start', 'End']);
    });

    test('Path with multiple points', () => {
        const pois = [
            createPOI('1', 'A', 0, 0, [{connectedPoiId: '2', distance: 1}, {connectedPoiId: '3', distance: 5}]),
            createPOI('2', 'B', 1, 0, [{connectedPoiId: '1', distance: 1}, {connectedPoiId: '4', distance: 2}]),
            createPOI('3', 'C', 5, 0, [{connectedPoiId: '1', distance: 5}, {connectedPoiId: '4', distance: 1}]),
            createPOI('4', 'D', 6, 0, [{connectedPoiId: '2', distance: 2}, {connectedPoiId: '3', distance: 1}])
        ];
        const path = aStar(pois, pois[0], pois[3]);
        expect(path.map(p => p.name)).toEqual(['A', 'B', 'D']);
    });

    test('No path available', () => {
        const pois = [
            createPOI('1', 'Start', 0, 0),
            createPOI('2', 'End', 1, 1)
        ];
        const path = aStar(pois, pois[0], pois[1]);
        expect(path).toEqual([]);
    });

    test('Start and end are the same', () => {
        const poi = createPOI('1', 'Start/End', 0, 0);
        const path = aStar([poi], poi, poi);
        expect(path).toEqual([poi]);
    });

    test('Complex path with obstacles', () => {
        const pois = [
            createPOI('1', 'Start', 0, 0, [{connectedPoiId: '2', distance: 1}, {connectedPoiId: '4', distance: 1}]),
            createPOI('2', 'B', 1, 0, [{connectedPoiId: '1', distance: 1}, {connectedPoiId: '3', distance: 1}]),
            createPOI('3', 'C', 2, 0, [{connectedPoiId: '2', distance: 1}, {connectedPoiId: '5', distance: 1}]),
            createPOI('4', 'D', 0, 1, [{connectedPoiId: '1', distance: 1}, {connectedPoiId: '6', distance: 1}]),
            createPOI('5', 'E', 2, 1, [{connectedPoiId: '3', distance: 1}, {connectedPoiId: '8', distance: 1}]),
            createPOI('6', 'F', 0, 2, [{connectedPoiId: '4', distance: 1}, {connectedPoiId: '7', distance: 1}]),
            createPOI('7', 'G', 1, 2, [{connectedPoiId: '6', distance: 1}, {connectedPoiId: '8', distance: 1}]),
            createPOI('8', 'End', 2, 2, [{connectedPoiId: '5', distance: 1}, {connectedPoiId: '7', distance: 1}])
        ];
        const path = aStar(pois, pois[0], pois[7]);
        expect(path.map(p => p.name)).toEqual(['Start', 'D', 'F', 'G', 'End']);
    });

    test('Path with equal cost alternatives', () => {
        const pois = [
            createPOI('1', 'Start', 0, 0, [{connectedPoiId: '2', distance: 1}, {connectedPoiId: '3', distance: 1}]),
            createPOI('2', 'A', 1, 0, [{connectedPoiId: '1', distance: 1}, {connectedPoiId: '4', distance: 1}]),
            createPOI('3', 'B', 0, 1, [{connectedPoiId: '1', distance: 1}, {connectedPoiId: '4', distance: 1}]),
            createPOI('4', 'End', 1, 1, [{connectedPoiId: '2', distance: 1}, {connectedPoiId: '3', distance: 1}])
        ];
        const path = aStar(pois, pois[0], pois[3]);
        expect(path.length).toBe(3);
        expect(path[0].name).toBe('Start');
        expect(path[2].name).toBe('End');
        // The middle point can be either 'A' or 'B' depending on how ties are broken
        expect(['A', 'B']).toContain(path[1].name);
    });
});
