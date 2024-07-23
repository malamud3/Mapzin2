//
//  VisualIndicatorService.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/07/2024.
//

import ARKit
import SceneKit

class VisualIndicatorService {
     func addVisualIndicator(at position: SCNVector3, to arView: ARSCNView, color: UIColor = .red) {
        let indicator = SCNNode(geometry: SCNSphere(radius: 0.05))
        indicator.position = position
        indicator.geometry?.firstMaterial?.diffuse.contents = color
        arView.scene.rootNode.addChildNode(indicator)
    }

     func addRedBox(at position: SCNVector3, to arView: ARSCNView) {
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        boxGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.position = position
        arView.scene.rootNode.addChildNode(boxNode)
    }
}
