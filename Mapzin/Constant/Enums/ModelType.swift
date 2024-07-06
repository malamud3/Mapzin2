//
//  ModelType.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SceneKit

enum ModelType {
    case cube
    case sphere
    
    func createNode(at position: SCNVector3) -> SCNNode {
        let geometry: SCNGeometry
        
        switch self {
        case .cube:
            geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        case .sphere:
            geometry = SCNSphere(radius: 0.1)
        }
        
        let node = SCNNode(geometry: geometry)
        node.position = position
        return node
    }
}
