//
//  BDMFileManger.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SceneKit

struct NodeData {
    let name: String
    let position: SCNVector3
    let type: NodeType
}

enum NodeType {
    case door
    case window
}

class BDMService {
    func parseSCNFile(named filename: String) -> [NodeData]? {
        guard let scene = SCNScene(named: filename) else {
            print("Failed to load scene file: \(filename)")
            return nil
        }

        var nodeDataArray: [NodeData] = []
        scene.rootNode.enumerateChildNodes { (node, _) in
            if node.position != SCNVector3(0, 0, 0) {
                let nodeType: NodeType
                if node.name?.hasPrefix("Door") == true {
                    nodeType = .door
                } else {
                    nodeType = .window
                }
                
                let nodeData = NodeData(
                    name: node.name ?? "Unnamed",
                    position: node.position,
                    type: nodeType
                )
                nodeDataArray.append(nodeData)
            }
        }

        print("Parsed \(nodeDataArray.count) nodes from the SCN file.")
        return nodeDataArray
    }

    func printNodeDetails(_ nodes: [NodeData]) {
        for node in nodes {
            print("Name: \(node.name), Type: \(node.type), Position: \(node.position)")
        }
    }
}
