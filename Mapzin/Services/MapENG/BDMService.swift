//
//  BDMFileManger.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//


import SceneKit

class BDMService {
    func parseSCNFile(named filename: String) -> [NodeData]? {
        guard let scene = SCNScene(named: filename) else {
            print("Failed to load scene file: \(filename)")
            return nil
        }

        var nodeDataArray: [NodeData] = []
        
        scene.rootNode.enumerateChildNodes { (node, _) in
            if node.position != SCNVector3Zero {
                let nodeType: NodeType
                if node.name?.hasPrefix("Door") == true {
                    nodeType = .door
                }
//                else if node.name?.hasPrefix("Window") == true {
//                    nodeType = .window
//                }
                else if node.name?.hasSuffix("Room0") == true {
                    nodeType = .room
                } else {
                    nodeType = .other
                }
                
                let nodeData = NodeData(
                    name: node.name ?? "Unnamed",
                    position: node.position,
                    type: nodeType
                )
                nodeDataArray.append(nodeData)
                print("Parsed node: \(nodeData.name), Position: \(nodeData.position), Type: \(nodeType)")
            }
        }

        return nodeDataArray
    }
}
