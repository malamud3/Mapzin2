import express from 'express';
import dotenv from 'dotenv';
import { MongoClient, ObjectId } from 'mongodb';

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
        return client.db('mapzin'); // Replace 'mapzin' with your actual database name
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
        const building = req.body;
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
