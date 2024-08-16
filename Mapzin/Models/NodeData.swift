//
//  NodeData.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/07/2024.
//

import Foundation
import SceneKit

enum NodeType {
    case door
    case stairs
    case room
    case wall
    case other
}

struct NodeData {
    let name: String
    let position: SCNVector3
    let type: NodeType
}
