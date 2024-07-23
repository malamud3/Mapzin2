//
//  FloorMap.swift
//  Mapzin
//
//  Created by Amir Malamud on 10/07/2024.
//

import Foundation
import SceneKit

struct FloorMap {
    let scene: SCNScene?
    
    init(fileName: String) {
        self.scene = SCNScene(named: fileName)
    }
}
