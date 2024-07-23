//
//  POI.swift
//  Mapzin
//
//  Created by Amir Malamud on 07/06/2024.
//

import SwiftUI
import ARKit

// Point of Interest
struct POI: Codable {
    let id: UUID
    let name: String
    let description: String
    let category: String
    let position: Position
    let buildingID: UUID
    let levelID: UUID
}
