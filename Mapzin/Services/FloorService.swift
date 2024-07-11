//
//  FloorDetectionService.swift
//  Mapzin
//
//  Created by Amir Malamud on 10/07/2024.
//

import ARKit

class FloorService {
    func identifyAndMarkFloor(in scene: SCNScene) {
        if let floorNode = scene.rootNode.childNode(withName: "floor", recursively: true) {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            floorNode.geometry?.materials = [material]
            print("Identified and marked floor node: \(floorNode)")
        } else {
            print("Floor node not found")
        }
    }
}
