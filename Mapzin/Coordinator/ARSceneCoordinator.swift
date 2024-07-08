//
//  ARSceneCoordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SwiftUI
import ARKit
import CoreMotion
import Combine

class ARSceneCoordinator: NSObject, ARSCNViewDelegate {
    var parent: ARSceneView
    private let parser: BDMParser
    private let floorDetector: FloorDetector
    private let stepCounterService: StepCounterService
    private var cancellables = Set<AnyCancellable>()
    
    init(parent: ARSceneView, parser: BDMParser, floorDetector: FloorDetector, stepCounterService: StepCounterService) {
        self.parent = parent
        self.parser = parser
        self.floorDetector = floorDetector
        self.stepCounterService = stepCounterService
        super.init()
        setupStepCounter()
    }
    
    func setupStepCounter() {
        stepCounterService.$stepCount
            .sink { [weak self] stepCount in
                self?.updateStepCount(stepCount)
            }
            .store(in: &cancellables)
        
        stepCounterService.$deviceMotion
            .sink { [weak self] deviceMotion in
                self?.updateDeviceMotion(deviceMotion)
            }
            .store(in: &cancellables)
        
        stepCounterService.startCountingSteps()
    }
    
    func updateStepCount(_ stepCount: Int) {
        print("Steps: \(stepCount)")
    }
    
    func updateDeviceMotion(_ deviceMotion: CMDeviceMotion?) {
        guard let motion = deviceMotion else { return }
        
        let attitude = motion.attitude
        let rotationMatrix = motion.attitude.rotationMatrix
        let gravity = motion.gravity
        let userAcceleration = motion.userAcceleration
        let heading = motion.heading
        
        print("Rotation (roll, pitch, yaw): (\(attitude.roll), \(attitude.pitch), \(attitude.yaw))")
        print("Rotation Matrix: \(rotationMatrix)")
        print("Gravity (x, y, z): (\(gravity.x), \(gravity.y), \(gravity.z))")
        print("User Acceleration (x, y, z): (\(userAcceleration.x), \(userAcceleration.y), \(userAcceleration.z))")
        print("Heading: \(heading)")
    }
    
    func updateARScene(with modelType: ModelType, at position: SCNVector3) {
        print("Updating AR Scene with model type: \(modelType) at position: \(position)")
        parent.sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        let node = modelType.createNode(at: position)
        parent.sceneView.scene.rootNode.addChildNode(node)
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let sceneView = parent.sceneView
        let location = gestureRecognize.location(in: sceneView)
        print("Handle tap at location: \(location)")
        let hitResults = sceneView.hitTest(location, options: [:])
        
        if let result = hitResults.first {
            let node = result.node
            print("Node tapped: \(node)")
 
        }
    }
    
    func loadScene() {
        guard let scene = SCNScene(named: "Primary_bdm.scn") else {
            print("Failed to load the scene")
            return
        }
        print("Loaded scene: Primary_bdm.scn")
        
        // Add the scene's root node to the ARKit scene
        parent.sceneView.scene.rootNode.addChildNode(scene.rootNode)
        
        // Identify and mark the floor in red
        identifyAndMarkFloor(in: scene)
    }
    
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
    
    func placeObjectsFromBDM(filePath: String) {
        guard let transforms = parser.parse(filePath: filePath),
              let floorTransform = floorDetector.identifyFloorPosition(from: transforms) else {
            print("Failed to parse BDM file or identify floor position")
            return
        }
        
        print("Parsed BDM file and identified floor position: \(floorTransform)")
        
        let floorSize = CGSize(width: 10, height: 10) // Example size, adjust as needed
        let redPlaneNode = createRedPlaneNode(size: floorSize)
        redPlaneNode.position = SCNVector3(floorTransform.columns.3.x, floorTransform.columns.3.y, floorTransform.columns.3.z)
        parent.sceneView.scene.rootNode.addChildNode(redPlaneNode)
        print("Placed red plane node at floor position: \(redPlaneNode.position)")
    }
    
    func createRedPlaneNode(size: CGSize) -> SCNNode {
        let planeGeometry = SCNPlane(width: size.width, height: size.height)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        planeGeometry.materials = [material]
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.eulerAngles.x = -.pi / 2 // Rotate the plane to be horizontal
        print("Created red plane node of size: \(size)")
        return planeNode
    }
}
