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

