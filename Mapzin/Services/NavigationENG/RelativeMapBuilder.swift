//
//  RelativeMapBuilder.swift
//  Mapzin
//
//  Created by Amir Malamud on 27/07/2024.
//

import ARKit
import SceneKit

class RelativeMapBuilder {
     var qrCodePosition: SCNVector3?
     var relativeMap: [NodeData] = []

    func setQRCodePosition(_ position: SCNVector3) {
        self.qrCodePosition = position
        // Clear existing map when a new QR code is scanned
        self.relativeMap.removeAll()
    }

    func addNode(_ node: SCNNode?) {
        guard let node = node else {
            print("Error: Invalid node")
            return
        }
        guard let qrPosition = qrCodePosition else {
            print("Error: QR code position not set")
            return
        }

        let relativePosition = SCNVector3(
            node.worldPosition.x - qrPosition.x,
            node.worldPosition.y - qrPosition.y,
            node.worldPosition.z - qrPosition.z
        )

        let nodeType = determineNodeType(node)
        let nodeData = NodeData(name: node.name ?? "Unknown", position: relativePosition, type: nodeType)
        relativeMap.append(nodeData)
    }

    private func determineNodeType(_ node: SCNNode) -> NodeType {
        let nodeTypes: [String: NodeType] = [
            "Door": .door,
            "Window": .window,
            "Room": .room
        ]
        
        for (key, type) in nodeTypes {
            if node.name?.contains(key) == true {
                return type
            }
        }
        return .other
    }

    func getRelativeMap() -> [NodeData] {
        return relativeMap
    }
}
