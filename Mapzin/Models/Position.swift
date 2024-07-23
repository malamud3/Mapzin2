//
//  Position.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/07/2024.
//

import Foundation
import SceneKit

// Position struct for coordinates
struct Position: Codable {
    let x: Float
    let y: Float
    let z: Float
    
    func toSCNVector3() -> SCNVector3 {
            return SCNVector3(x, y, z)
        }
}
