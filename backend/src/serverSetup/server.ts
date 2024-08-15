import express from 'express';
import dotenv from 'dotenv';
import { connectToDatabase } from '../config/database';
import buildingRoutes from '../routes/buildingRoutes';
import floorRoutes from "../routes/floorRoutes";
import poiRoutes from "../routes/poiRoutes";

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
    res.send('Mapzin Server is running!');
});

app.use('/api/buildings', buildingRoutes);
app.use('/api/buildings/:buildingId/floors', floorRoutes);
app.use('/api/buildings/:buildingId/floors/:floorId/pois', poiRoutes);

async function startServer() {
    await connectToDatabase();

    app.listen(port, () => {
        console.log(`Server is running on port ${port}`);
    });
}

startServer();
