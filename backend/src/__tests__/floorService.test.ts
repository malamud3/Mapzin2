import { ObjectId } from 'mongodb';
import { MongoClient } from 'mongodb';
import { MongoMemoryServer } from 'mongodb-memory-server';
import * as floorService from '../services/CRUD/floorService';
import { Floor } from '../entities/Floor';

let mongoServer: MongoMemoryServer;
let mongoClient: MongoClient;

beforeAll(async () => {
    mongoServer = await MongoMemoryServer.create();
    const mongoUri = mongoServer.getUri();
    mongoClient = new MongoClient(mongoUri);
    await mongoClient.connect();

    // Mock the getDb function
    jest.spyOn(require('../config/database'), 'getDb').mockReturnValue(mongoClient.db());
});

afterAll(async () => {
    await mongoClient.close();
    await mongoServer.stop();
});

describe('Floor Service', () => {
    const sampleBuilding = {
        _id: new ObjectId(),
        name: 'Test Building',
        address: '123 Test St',
        location: { longitude: '0', latitude: '0' },
        floors: []
    };

    const sampleFloor: Omit<Floor, '_id'> = {
        level: 1,
        name: 'Ground Floor',
        pois: [
            {
                name: 'Main Entrance',
                type: 'entrance',
                location: { x: 0, y: 0,z: 0 },
                floor: 1, // Add the 'floor' property
                description: 'Main building entrance',
                connections: []
            }
        ]
    };

    beforeEach(async () => {
        const db = mongoClient.db();
        await db.collection('buildings').deleteMany({});
        await db.collection('buildings').insertOne(sampleBuilding);
    });

    describe('addFloor', () => {
        it('should add a new floor to a building', async () => {
            const result = await floorService.addFloor(sampleBuilding._id.toHexString(), sampleFloor);

            expect(result).toMatchObject(sampleFloor);
            expect(result._id).toBeDefined();

            const updatedBuilding = await mongoClient.db().collection('buildings').findOne({ _id: sampleBuilding._id });
            expect(updatedBuilding?.floors).toHaveLength(1);
            expect(updatedBuilding?.floors[0]).toMatchObject(sampleFloor);
        });

        it('should throw an error if building is not found', async () => {
            const nonExistentId = new ObjectId().toHexString();
            await expect(floorService.addFloor(nonExistentId, sampleFloor)).rejects.toThrow('Building not found');
        });
    });

    describe('getFloor', () => {
        it('should retrieve a floor from a building', async () => {
            const addedFloor = await floorService.addFloor(sampleBuilding._id.toHexString(), sampleFloor);
            const result = await floorService.getFloor(sampleBuilding._id.toHexString(), addedFloor._id as string);

            expect(result).toMatchObject(sampleFloor);
            expect(result?._id).toBe(addedFloor._id);
        });

        it('should return null if floor is not found', async () => {
            const nonExistentId = new ObjectId().toHexString();
            const result = await floorService.getFloor(sampleBuilding._id.toHexString(), nonExistentId);

            expect(result).toBeNull();
        });
    });

    describe('updateFloor', () => {
        it('should update an existing floor', async () => {
            const addedFloor = await floorService.addFloor(sampleBuilding._id.toHexString(), sampleFloor);
            const updatedFloorData = { ...sampleFloor, name: 'Updated Floor Name' };

            const result = await floorService.updateFloor(sampleBuilding._id.toHexString(), addedFloor._id as string, updatedFloorData);

            expect(result).toBe(true);

            const updatedFloor = await floorService.getFloor(sampleBuilding._id.toHexString(), addedFloor._id as string);
            expect(updatedFloor?.name).toBe('Updated Floor Name');
        });

        it('should return false if floor is not found', async () => {
            const nonExistentId = new ObjectId().toHexString();
            const result = await floorService.updateFloor(sampleBuilding._id.toHexString(), nonExistentId, sampleFloor);

            expect(result).toBe(false);
        });
    });

    describe('deleteFloor', () => {
        it('should delete a floor from a building', async () => {
            const addedFloor = await floorService.addFloor(sampleBuilding._id.toHexString(), sampleFloor);
            const result = await floorService.deleteFloor(sampleBuilding._id.toHexString(), addedFloor._id as string);

            expect(result).toBe(true);

            const deletedFloor = await floorService.getFloor(sampleBuilding._id.toHexString(), addedFloor._id as string);
            expect(deletedFloor).toBeNull();
        });

        it('should return false if floor is not found', async () => {
            const nonExistentId = new ObjectId().toHexString();
            const result = await floorService.deleteFloor(sampleBuilding._id.toHexString(), nonExistentId);

            expect(result).toBe(false);
        });
    });
});
