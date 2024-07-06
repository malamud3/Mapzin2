//
//  ARSceneCoordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SwiftUI
import ARKit

class ARSceneCoordinator: NSObject, ARSCNViewDelegate {
    var parent: ARSceneView
    private let parser: BDMParser
    private let floorDetector: FloorDetector
    
    init(parent: ARSceneView, parser: BDMParser, floorDetector: FloorDetector) {
        self.parent = parent
        self.parser = parser
        self.floorDetector = floorDetector
    }
    
    func updateARScene(with modelType: ModelType, at position: SCNVector3) {
        parent.sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        let node = modelType.createNode(at: position)
        parent.sceneView.scene.rootNode.addChildNode(node)
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let sceneView = parent.sceneView
        let location = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: [:])
        
        if let result = hitResults.first {
            let node = result.node
            if let geometry = node.geometry {
                geometry.firstMaterial?.diffuse.contents = UIColor.random()
            }
        }
    }
    
    func loadScene() {
        // Load the scene from the .scn file
        guard let scene = SCNScene(named: "Primary_bdm.scn") else {
            print("Failed to load the scene")
            return
        }
        
        // Add the scene's root node to the ARKit scene
        parent.sceneView.scene.rootNode.addChildNode(scene.rootNode)
        
        // Identify and mark the floor in red
        identifyAndMarkFloor(in: scene)
    }
    
    func identifyAndMarkFloor(in scene: SCNScene) {
        // Example logic to identify the floor node by name or other criteria
        // Adjust this logic based on how your floor is represented in the .scn file
        if let floorNode = scene.rootNode.childNode(withName: "floor", recursively: true) {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            floorNode.geometry?.materials = [material]
        } else {
            print("Floor node not found")
        }
    }
    
    func placeObjectsFromBDM(filePath: String) {
        // Parse the BDM file to get positions
        guard let transforms = parser.parse(filePath: filePath),
              let floorTransform = floorDetector.identifyFloorPosition(from: transforms) else { return }
        
        // Place a red plane at the floor position
        let floorSize = CGSize(width: 10, height: 10) // Example size, adjust as needed
        let redPlaneNode = createRedPlaneNode(size: floorSize)
        redPlaneNode.position = SCNVector3(floorTransform.columns.3.x, floorTransform.columns.3.y, floorTransform.columns.3.z)
        parent.sceneView.scene.rootNode.addChildNode(redPlaneNode)
    }
    
    func createRedPlaneNode(size: CGSize) -> SCNNode {
        let planeGeometry = SCNPlane(width: size.width, height: size.height)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        planeGeometry.materials = [material]
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.eulerAngles.x = -.pi / 2 // Rotate the plane to be horizontal
        return planeNode
    }
}
