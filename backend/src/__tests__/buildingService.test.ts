import { ObjectId } from 'mongodb';
import * as buildingService from '../services/CRUD/buildingService';
import { getDb } from '../config/database';
import { Building, BuildingDocument } from '../entities/Building';
import * as BuildingModel from '../entities/Building';

// Extend Jest's expect
import { expect } from '@jest/globals';

// Mock the database module
jest.mock('../config/database', () => ({
    getDb: jest.fn(),
}));

// Mock the Building model
jest.mock('../entities/Building', () => ({
    ...jest.requireActual('../entities/Building'),
    isValidBuilding: jest.fn(),
}));

// Explicitly type the mocked function
const mockedIsValidBuilding = BuildingModel.isValidBuilding as jest.MockedFunction<typeof BuildingModel.isValidBuilding>;

const sampleBuilding: Omit<Building, '_id'> = {
    name: 'Test Building',
    address: '123 Test St, Test City, TS 12345',
    location: {
        longitude: '123.456',
        latitude: '78.910',
    },
    floors: [
        {
            level: 1,
            name: 'Ground Floor',
            pois: [
                {
                    name: 'Main Entrance',
                    type: 'entrance',
                    location: { x: 0, y: 0, z: 0 },
                    description: 'Main building entrance',
                    connections: [],
                    floor: 1  // Add this line
                },
            ],
        },
    ],
};

    // Mock collection methods
    const mockCollection = {
        insertOne: jest.fn(),
        find: jest.fn(),
        findOne: jest.fn(),
        updateOne: jest.fn(),
        deleteOne: jest.fn(),
    };

    // Mock database
    const mockDb = {
        collection: jest.fn().mockReturnValue(mockCollection),
    };

    beforeEach(() => {
        // Clear all mocks before each test
        jest.clearAllMocks();
        (getDb as jest.Mock).mockReturnValue(mockDb);
        mockedIsValidBuilding.mockImplementation((data: any): data is Building => Boolean(data.name));
    });

    describe('createBuilding', () => {
        it('should create a new building', async () => {
            const mockInsertedId = new ObjectId();
            mockCollection.insertOne.mockResolvedValue({ insertedId: mockInsertedId });

            const result = await buildingService.createBuilding(sampleBuilding);

            expect(mockDb.collection).toHaveBeenCalledWith('buildings');
            expect(mockCollection.insertOne).toHaveBeenCalledWith(expect.objectContaining(sampleBuilding));
            expect(result).toEqual(expect.objectContaining({ ...sampleBuilding, _id: mockInsertedId.toHexString() }));
        });

        it('should throw an error if building data is invalid', async () => {
            mockedIsValidBuilding.mockImplementation((data: any): data is Building => false);
            const invalidBuilding = { ...sampleBuilding, name: '' };
            await expect(buildingService.createBuilding(invalidBuilding as Building)).rejects.toThrow('Invalid building data');
        });
    });

    // ... (other test cases remain the same)

    describe('updateBuilding', () => {
        it('should update a building', async () => {
            const mockId = new ObjectId();
            mockCollection.updateOne.mockResolvedValue({ matchedCount: 1 } as any);

            const result = await buildingService.updateBuilding(mockId.toHexString(), sampleBuilding);

            expect(mockDb.collection).toHaveBeenCalledWith('buildings');
            expect(mockCollection.updateOne).toHaveBeenCalledWith(
                { _id: mockId },
                { $set: expect.objectContaining(sampleBuilding) }
            );
            expect(result).toBe(true);
        });

        it('should return false if building is not found', async () => {
            mockCollection.updateOne.mockResolvedValue({ matchedCount: 0 } as any);

            const result = await buildingService.updateBuilding(new ObjectId().toHexString(), sampleBuilding);

            expect(result).toBe(false);
        });

        it('should throw an error if building data is invalid', async () => {
            mockedIsValidBuilding.mockImplementation((data: any): data is Building => false);
            const invalidBuilding = { ...sampleBuilding, name: '' };
            await expect(buildingService.updateBuilding(new ObjectId().toHexString(), invalidBuilding as Building)).rejects.toThrow('Invalid building data');
        });
    });


