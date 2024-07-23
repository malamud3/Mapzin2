//
//  NodeData.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/07/2024.
//

import Foundation
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
