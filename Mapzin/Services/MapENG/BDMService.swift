import SceneKit

class BDMService {
    func parseSCNFile(named filename: String) -> [NodeData]? {
        guard let scene = SCNScene(named: filename) else {
            print("Failed to load scene file: \(filename)")
            return nil
        }

        var nodeDataArray: [NodeData] = []
        
        scene.rootNode.enumerateChildNodes { (node, _) in
            // Debug: Print all node names and their immediate properties
            print("Node: \(node.name ?? "Unnamed"), Position: \(node.position), Has Geometry: \(node.geometry != nil)")
            
            if let geometry = node.geometry {
                let (min, max) = geometry.boundingBox
                print("  Geometry Bounding Box - Min: \(min), Max: \(max)")
            }
            
            if node.position != SCNVector3Zero {
                let nodeType: NodeType
                if node.name?.hasPrefix("Door") == true {
                    nodeType = .door
                } else if node.name?.hasPrefix("Window") == true {
                    nodeType = .window
                } else if node.name?.hasSuffix("Room0") == true {
                    nodeType = .room
                } else {
                    nodeType = .other
                }
                
//                // Try different methods to get bounding box
//                let boundingBox: BoundingBox
//                if let geometry = node.geometry {
//                    let (min, max) = geometry.boundingBox
//                    boundingBox = BoundingBox(
//                        width: max.x - min.x,
//                        height: max.y - min.y,
//                        depth: max.z - min.z
//                    )
//                } else {
//                    // Fallback to node's bounding box if geometry is nil
//                    let (min, max) = node.boundingBox
//                    boundingBox = BoundingBox(
//                        width: max.x - min.x,
//                        height: max.y - min.y,
//                        depth: max.z - min.z
//                    )
//                }
                
                let nodeData = NodeData(
                    name: node.name ?? "Unnamed",
                    position: node.position,
                    type: nodeType
//                    boundingBox: boundingBox
                )
                nodeDataArray.append(nodeData)
                
                print("Parsed node: \(nodeData.name), Position: \(nodeData.position), Type: \(nodeType)")
            }
        }

        print("Parsed \(nodeDataArray.count) nodes from the SCN file.")
        return nodeDataArray
    }
}

