import { PriorityQueue } from 'typescript-collections';
import {POI} from "../entities/POI";

interface Node {
    poi: POI;
    f: number;
    g: number;
    h: number;
    parent: Node | null;
}

function euclideanDistance(a: POI, b: POI): number {
    const dx = a.location.x - b.location.x;
    const dy = a.location.y - b.location.y;
    return Math.sqrt(dx * dx + dy * dy);
}

export function aStar(pois: POI[], start: POI, end: POI): POI[] {
    console.log(`Starting A* algorithm from ${start._id} to ${end._id}`);
    const openSet = new PriorityQueue<Node>((a, b) => b.f - a.f);
    const openSetMap = new Map<string, Node>();
    const closedSet = new Set<string>();
    const startNode: Node = { poi: start, f: 0, g: 0, h: 0, parent: null };

    openSet.add(startNode);
    openSetMap.set(start._id!.toString(), startNode);

    while (!openSet.isEmpty()) {
        const current = openSet.dequeue()!;
        openSetMap.delete(current.poi._id!.toString());

        console.log(`Exploring node: ${current.poi._id}, f: ${current.f}, g: ${current.g}, h: ${current.h}`);

        if (current.poi._id === end._id) {
            console.log('Path found!');
            return reconstructPath(current);
        }

        closedSet.add(current.poi._id!.toString());

        for (const connection of current.poi.connections) {
            const neighborPOI = pois.find(p => p._id!.toString() === connection.connectedPoiId);
            if (!neighborPOI || closedSet.has(neighborPOI._id!.toString())) continue;

            const tentativeG = current.g + connection.distance;
            const h = euclideanDistance(neighborPOI, end);
            const f = tentativeG + h;

            console.log(`  Neighbor: ${neighborPOI._id}, tentative g: ${tentativeG}, h: ${h}, f: ${f}`);

            const existingNeighbor = openSetMap.get(neighborPOI._id!.toString());
            if (!existingNeighbor) {
                const neighborNode: Node = {
                    poi: neighborPOI,
                    f: f,
                    g: tentativeG,
                    h: h,
                    parent: current
                };
                openSet.add(neighborNode);
                openSetMap.set(neighborPOI._id!.toString(), neighborNode);
                console.log(`  Added new node to open set: ${neighborPOI._id}`);
            } else if (tentativeG < existingNeighbor.g) {
                console.log(`  Updating existing node: ${neighborPOI._id}`);
                // Update existing node
                existingNeighbor.g = tentativeG;
                existingNeighbor.f = f;
                existingNeighbor.parent = current;

                // Re-add the updated node to maintain heap property
                openSet.add(existingNeighbor);
            }
        }
    }

    console.log('No path found');
    return []; // No path found
}

function reconstructPath(endNode: Node): POI[] {
    const path: POI[] = [];
    let current: Node | null = endNode;

    while (current !== null) {
        path.unshift(current.poi);
        current = current.parent;
    }

    console.log('Reconstructed path:', path.map(poi => poi._id).join(' -> '));
    return path;
}
