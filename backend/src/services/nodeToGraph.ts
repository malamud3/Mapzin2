import {POI} from "../entities/POI";
import {Connection} from "../entities/Connection";


//Swap  z and y. Z is static base the first node.position.y

export const NodeBoundaryFix = (nodes: NodeBoundary[]): NodeBoundary[] => {
    if (nodes.length === 0) {
        return [];
    }

    const referenceZ = nodes[0].position.y;

    return nodes.map(node => ({
        name: node.name,
        position: {
            x: node.position.x,
            y: node.position.z,
            z: referenceZ
        },
        type: node.type
    }));
};
// Helper function to create a POI object
function createPOI(name: string, x: number, y: number, z: number, floor: number, description: string, connections: Array<{ connectedPoiId: string; distance: number }>): POI {
    return {
        name,
        type: "default",
        location: { x, y, z },
        floor,
        description,
        connections
    };
}
// Parse the JSON data
const testCases = JSON.parse(`[
  // ... (the entire JSON string would go here)
]`);

// const convertNode2DToPOI = (node: Node2D, floor: number, connections: Connection[]): POI => {
//     const description = `POI of type ${node.type}`;
//
//     return {
//         name: node.name,
//         type: node.type,
//         location: {
//             x: node.position.x,
//             y: node.position.z,
//         },
//         floor,
//         description,
//         connections
//     };
// };

