//
//  POIService.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import Foundation
import SceneKit

class POIService {
    private var buildingID: UUID
    private var levelID: UUID

    init(buildingID: UUID, levelID: UUID) {
        self.buildingID = buildingID
        self.levelID = levelID
    }

    func createPOIs(from nodes: [NodeData]) -> [POI] {
        var pois: [POI] = []
        
        for node in nodes {
            let position = Position(x: node.position.x, y: node.position.y, z: node.position.z)
            let poi = POI(
                id: UUID(),
                name: node.name,
                description: "\(node.type) located at \(node.position)",
                category: String(describing: node.type),
                position: position,
                buildingID: buildingID,
                levelID: levelID
            )
            pois.append(poi)
        }
        
        return pois
    }

    func printPOIDetails(_ pois: [POI]) {
        for poi in pois {
            print("ID: \(poi.id), Name: \(poi.name), Description: \(poi.description), Category: \(poi.category), Position: \(poi.position), BuildingID: \(poi.buildingID), LevelID: \(poi.levelID)")
        }
    }
}
