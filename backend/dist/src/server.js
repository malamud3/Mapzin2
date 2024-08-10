"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const dotenv_1 = __importDefault(require("dotenv"));
const mongodb_1 = require("mongodb");
dotenv_1.default.config();
const app = (0, express_1.default)();
const port = process.env.PORT || 3000;
app.use(express_1.default.json());
const uri = process.env.MONGODB_URI;
const client = new mongodb_1.MongoClient(uri);
let db;
function connectToDatabase() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            yield client.connect();
            console.log('Connected to MongoDB Atlas');
            return client.db('mapzin'); // Replace 'mapzin' with your actual database name
        }
        catch (error) {
            console.error('MongoDB Atlas connection error:', error);
            process.exit(1);
        }
    });
}
app.get('/', (req, res) => {
    res.send('Mapzin Server is running!');
});
// Building CRUD operations
app.post('/api/buildings', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const building = req.body;
        const result = yield db.collection('buildings').insertOne(building);
        res.status(201).json(result);
    }
    catch (error) {
        res.status(500).json({ message: 'Error creating building', error });
    }
}));
app.get('/api/buildings', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const buildings = yield db.collection('buildings').find().toArray();
        res.json(buildings);
    }
    catch (error) {
        res.status(500).json({ message: 'Error fetching buildings', error });
    }
}));
app.listen(port, () => __awaiter(void 0, void 0, void 0, function* () {
    db = yield connectToDatabase();
    console.log(`Server is running on port ${port}`);
}));
// Graceful shutdown
process.on('SIGINT', () => __awaiter(void 0, void 0, void 0, function* () {
    yield client.close();
    console.log('MongoDB connection closed');
    process.exit(0);
}));
