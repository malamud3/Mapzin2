//
//  VisualIndicatorService.swift
//  Mapzin
//
//  Created by Amir Malamud on 20/07/2024.
//


import SwiftUI
import SceneKit

class VisualIndicatorService {
    static func createARObjects(from nodes: [NodeData]) -> [ARObject] {
        return nodes.map { nodeData in
            ARObject(
                name: nodeData.name,
                position: nodeData.position,
                color: colorForNodeType(nodeData.type)
            )
        }
    }
    
    private static func colorForNodeType(_ type: NodeType) -> UIColor {
        switch type {
        case .door:
            return .brown
        case .stairs:
            return .orange
        case .room:
            return .blue
        case .wall:
            return .gray
        case .other:
            return .green
        }
    }
}
