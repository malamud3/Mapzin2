//
//  Floor.swift
//  Mapzin
//
//  Created by Amir Malamud on 07/07/2024.
//

import Foundation

struct Floor: Identifiable, Codable {
    let id: UUID
    let name: String
    let levelIndex: Int
    let pois: [POI]
    let mapImage: String
}
