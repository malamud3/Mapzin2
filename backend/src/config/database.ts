// src/config/database.ts
import { MongoClient, Db } from 'mongodb';
import dotenv from 'dotenv';

dotenv.config(); // Ensure this is called at the beginning of the file

const uri = process.env.MONGODB_URI;
let client: MongoClient;
let db: Db;

if (!uri) {
    console.error('MONGODB_URI is not defined in the environment variables');
    process.exit(1);
}

export async function connectToDatabase(): Promise<void> {
    if (typeof uri !== 'string') {
        throw new Error('MONGODB_URI must be a string');
    }

    try {
        client = new MongoClient(uri);
        await client.connect();
        db = client.db('mapzin'); // Replace 'mapzin' with your actual database name
        console.log('Connected to MongoDB Atlas');
    } catch (error) {
        console.error('MongoDB Atlas connection error:', error);
        process.exit(1);
    }
}

export function getDb(): Db {
    if (!db) {
        throw new Error('Database not initialized. Call connectToDatabase first.');
    }
    return db;
}

export function closeDatabase(): Promise<void> {
    if (client) {
        return client.close();
    }
    return Promise.resolve();
}
