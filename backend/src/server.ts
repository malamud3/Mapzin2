import express from 'express';
import dotenv from 'dotenv';
import { MongoClient, ObjectId } from 'mongodb';
import {Building, isValidBuilding} from './types/Building';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

const uri = process.env.MONGODB_URI as string;
const client = new MongoClient(uri);

let db: any;

async function connectToDatabase() {
    try {
        await client.connect();
        console.log('Connected to MongoDB Atlas');
        return client.db('mapzin');
    } catch (error) {
        console.error('MongoDB Atlas connection error:', error);
        process.exit(1);
    }
}

app.get('/', (req, res) => {
    res.send('Mapzin Server is running!');
});

// Building CRUD operations
app.post('/api/buildings', async (req, res) => {
    try {
        const buildingData = req.body;

        // Validate the incoming data
        if (!isValidBuilding(buildingData)) {
            return res.status(400).json({ message: 'Invalid building data' });
        }

        // If validation passes, we can safely assert the type
        const building: Building = buildingData as Building;

        const result = await db.collection('buildings').insertOne(building);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ message: 'Error creating building', error });
    }
});

app.get('/api/buildings', async (req, res) => {
    try {
        const buildings = await db.collection('buildings').find().toArray();
        res.json(buildings);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching buildings', error });
    }
});

app.get('/api/buildings/:id', async (req, res) => {
    try {
        const id = new ObjectId(req.params.id);
        const building = await db.collection('buildings').findOne({ _id: id });
        if (building) {
            res.json(building);
        } else {
            res.status(404).json({ message: 'Building not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error fetching building', error });
    }
});

app.put('/api/buildings/:id', async (req, res) => {
    try {
        const id = new ObjectId(req.params.id);
        const buildingData = req.body;

        // Validate the incoming data
        if (!isValidBuilding(buildingData)) {
            return res.status(400).json({ message: 'Invalid building data' });
        }

        // If validation passes, we can safely assert the type
        const updatedBuilding = buildingData as Building;

        const result = await db.collection('buildings').updateOne(
            { _id: id },
            { $set: updatedBuilding }
        );
        if (result.matchedCount > 0) {
            res.json({ message: 'Building updated successfully' });
        } else {
            res.status(404).json({ message: 'Building not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error updating building', error });
    }
});

app.delete('/api/buildings/:id', async (req, res) => {
    try {
        const id = new ObjectId(req.params.id);
        const result = await db.collection('buildings').deleteOne({ _id: id });
        if (result.deletedCount > 0) {
            res.json({ message: 'Building deleted successfully' });
        } else {
            res.status(404).json({ message: 'Building not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error deleting building', error });
    }
});

app.listen(port, async () => {
    db = await connectToDatabase();
    console.log(`Server is running on port ${port}`);
});

// Graceful shutdown
process.on('SIGINT', async () => {
    await client.close();
    console.log('MongoDB connection closed');
    process.exit(0);
});
