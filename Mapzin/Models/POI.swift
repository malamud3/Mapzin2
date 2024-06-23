//
//  POI.swift
//  Mapzin
//
//  Created by Amir Malamud on 07/06/2024.
//

import SwiftUI
import ARKit

struct POI {
       let name: String
       let description: String
       let position: SCNVector3
   }
// Sample POI data
let pois = [
    POI(name: "Entrance", description: "Main entrance of the building", position: SCNVector3(0.5, 0, -1)),
    POI(name: "Elevator", description: "Elevator to all floors", position: SCNVector3(-0.5, 0, -1)),
    POI(name: "Office", description: "Office of the building manager", position: SCNVector3(0, 0, -1.5))
]
