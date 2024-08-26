import fs from 'fs';
import { aStar } from './aStar';
import { POI } from '../entities/POI';

// Load JSON data from a file
const data = fs.readFileSync('poi_maps.json', 'utf8');
const poiMaps: { level: number; nodes: { poi: POI; f: number; g: number; h: number; parent: POI | null }[]; solution: string[] }[] = JSON.parse(data);

// Function to run A* algorithm on a specific level
function runAStarOnLevel(level: number) {
    const levelData = poiMaps.find((map) => map.level === level);
    if (!levelData) {
        console.error('Level not found!');
        return;
    }

    const pois = levelData.nodes.map(node => node.poi);
    const start = pois.find(poi => poi.name === levelData.solution[0])!;
    const end = pois.find(poi => poi.name === levelData.solution[levelData.solution.length - 1])!;

    const result = aStar(pois, start, end);
    // console.log(⁠ Graph level: ${level} ⁠);
    // console.log(⁠ Expected solution: ${levelData.solution} ⁠);
    // console.log(⁠ A* result: ${result.map(poi => poi.name)}\n ⁠);
}

// Run A* on different levels
runAStarOnLevel(7);
// for (let level = 1; level <= 10; level++) {
//     runAStarOnLevel(level);
// }
