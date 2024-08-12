//
//  POIService.swift
//  Mapzin
//
//  Created by Amir Malamud on 11/08/2024.
//

import Foundation
import SceneKit

class POIService {
    func createPOI(from nodeData: NodeData, buildingID: UUID, levelID: UUID) -> POI {
        let id = UUID()
        let name = nodeData.name
        let description = generateDescription(for: nodeData)
        let category = categoryFromNodeType(nodeData.type)
        let position = Position(x: nodeData.position.x, y: nodeData.position.y, z: nodeData.position.z)
        
        return POI(id: id,
                   name: name,
                   description: description,
                   category: category,
                   position: position,
                   buildingID: buildingID,
                   levelID: levelID)
    }
    
    private func generateDescription(for nodeData: NodeData) -> String {
        switch nodeData.type {
        case .door:
            return "A door in the building."
        case .window:
            return "A window in the building."
        case .room:
            return "A room in the building."
        case .other:
            return "A point of interest in the building."
        }
    }
    
    private func categoryFromNodeType(_ type: NodeType) -> String {
        switch type {
        case .door:
            return "Door"
        case .window:
            return "Window"
        case .room:
            return "Room"
        case .other:
            return "Other"
        }
    }
}
