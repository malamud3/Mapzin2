//
//  MockData.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/07/2024.
//

import Foundation
import CoreLocation

struct MockData {
    // Mock Position data
    static let position1 = Position(x: -0.568, y: -0.478, z: -1.851)
    static let position2 = Position(x: -8, y: 15.0, z: 0.622)
    
    // Mock POI data
    static let poi1 = POI(id: UUID(), name: "Entrance", description: "Main entrance of the building", category: "Entrance", position: position1, buildingID: UUID(), levelID: UUID())
    static let poi2 = POI(id: UUID(), name: "Door", description: "Main conference room on the floor", category: "Meeting Room", position: position2, buildingID: UUID(), levelID: UUID())
    
    // Mock Floor data
    static let floor = Floor(id: UUID(), name: "Ground Floor", levelIndex: 0, pois: [poi1, poi2], mapImage: "ground_floor_map.png")
    
    // Mock Building data
    static let building = Building(name: "Tech Hub", imageName: "tech_hub.png", coordinates: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), address: "123 Tech Lane, San Francisco, CA", floors: [floor], link: "https://www.techhub.com")
}
