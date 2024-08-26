//
//  genralFuncs.swift
//  Mapzin
//
//  Created by Amir Malamud on 26/08/2024.
//

import Foundation
import SceneKit

 func calculateDistance(from start: SCNVector3, to end: SCNVector3) -> Float {
    let dx = end.x - start.x
    let dy = end.y - start.y
    let dz = end.z - start.z
    return sqrt(dx*dx + dy*dy + dz*dz)
}
