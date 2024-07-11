////
////  ARSceneCoordinator.swift
////  Mapzin
////
////  Created by Amir Malamud on 23/06/2024.
////
//
//import SwiftUI
//import ARKit
//import CoreMotion
//import Combine
//
//class ARSceneCoordinator: NSObject, ARSCNViewDelegate {
//    var parent: ARSceneView
//    private let parser: BDMParser
//    private let floorDetector: FloorDetector
//    private let positionTrackingService: PositionTrackingService
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(parent: ARSceneView, parser: BDMParser, floorDetector: FloorDetector, positionTrackingService: PositionTrackingService) {
//        self.parent = parent
//        self.parser = parser
//        self.floorDetector = floorDetector
//        self.positionTrackingService = positionTrackingService
//        super.init()
//        setupPositionTracking()
//    }
//    
//    private func setupPositionTracking() {
//        positionTrackingService.$stepCount
//            .sink { [weak self] stepCount in
//                self?.updateStepCount(stepCount)
//            }
//            .store(in: &cancellables)
//        
//        positionTrackingService.$deviceMotion
//            .sink { [weak self] deviceMotion in
//                self?.updateDeviceMotion(deviceMotion)
//            }
//            .store(in: &cancellables)
//        
//        positionTrackingService.$currentPosition
//            .sink { [weak self] currentPosition in
//                self?.updateCurrentPosition(currentPosition)
//            }
//            .store(in: &cancellables)
//        
//        positionTrackingService.$angleInDegrees
//            .sink { [weak self] angleInDegrees in
//                self?.updateAngleInDegrees(angleInDegrees)
//            }
//            .store(in: &cancellables)
//        
//        positionTrackingService.$odometer
//            .sink { [weak self] odometer in
//                self?.updateOdometer(odometer)
//            }
//            .store(in: &cancellables)
//        
//        positionTrackingService.startTracking()
//    }
//
//    private func updateStepCount(_ stepCount: Int) {
//        print("Steps: \(stepCount)")
//    }
//
//    private func updateDeviceMotion(_ deviceMotion: CMDeviceMotion?) {
//        guard let motion = deviceMotion else { return }
//        
//        let attitude = motion.attitude
//        let rotationMatrix = motion.attitude.rotationMatrix
//        let gravity = motion.gravity
//        let userAcceleration = motion.userAcceleration
//        let heading = motion.heading
//        
//        print(String(format: "Rotation (roll, pitch, yaw): (%.3f, %.3f, %.3f)", attitude.roll, attitude.pitch, attitude.yaw))
//        print(String(format: "Rotation Matrix: CMRotationMatrix(m11: %.3f, m12: %.3f, m13: %.3f, m21: %.3f, m22: %.3f, m23: %.3f, m31: %.3f, m32: %.3f, m33: %.3f)",
//                     rotationMatrix.m11, rotationMatrix.m12, rotationMatrix.m13,
//                     rotationMatrix.m21, rotationMatrix.m22, rotationMatrix.m23,
//                     rotationMatrix.m31, rotationMatrix.m32, rotationMatrix.m33))
//        print(String(format: "Gravity (x, y, z): (%.3f, %.3f, %.3f)", gravity.x, gravity.y, gravity.z))
//        print(String(format: "User Acceleration (x, y, z): (%.3f, %.3f, %.3f)", userAcceleration.x, userAcceleration.y, userAcceleration.z))
//        print(String(format: "Heading: %.3f", heading))
//    }
//
//    private func updateCurrentPosition(_ position: SIMD3<Float>) {
//        let cylindricalCoordinates = positionTrackingService.getCylindricalCoordinates()
//        print(String(format: "Current Position in Cylindrical Coordinates: (r: %.3f, θ: %.3f°, z: %.3f)", cylindricalCoordinates.r, cylindricalCoordinates.theta, cylindricalCoordinates.z))
//    }
//
//    private func updateAngleInDegrees(_ angleInDegrees: Float) {
//        print(String(format: "Angle according to X Y axis in degrees: %.3f", angleInDegrees))
//    }
//
//    private func updateOdometer(_ odometer: Double) {
//        print(String(format: "Odometer: %.3f meters", odometer))
//    }
//    
//    func updateARScene(with modelType: ModelType, at position: SCNVector3) {
//        print("Updating AR Scene with model type: \(modelType) at position: \(position)")
//        parent.sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
//        let node = modelType.createNode(at: position)
//        parent.sceneView.scene.rootNode.addChildNode(node)
//    }
//    
//    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
//        let sceneView = parent.sceneView
//        let location = gestureRecognize.location(in: sceneView)
//        print("Handle tap at location: \(location)")
//        let hitResults = sceneView.hitTest(location, options: [:])
//        
//        if let result = hitResults.first {
//            let node = result.node
//            print("Node tapped: \(node)")
//        }
//    }
//    
//    func loadScene() {
//        guard let scene = SCNScene(named: "Primary_bdm.scn") else {
//            print("Failed to load the scene")
//            return
//        }
//        print("Loaded scene: Primary_bdm.scn")
//        
//        // Add the scene's root node to the ARKit scene
//        parent.sceneView.scene.rootNode.addChildNode(scene.rootNode)
//        
//        // Identify and mark the floor in red
//        identifyAndMarkFloor(in: scene)
//    }
//    
//    private func identifyAndMarkFloor(in scene: SCNScene) {
//        if let floorNode = scene.rootNode.childNode(withName: "floor", recursively: true) {
//            let material = SCNMaterial()
//            material.diffuse.contents = UIColor.red
//            floorNode.geometry?.materials = [material]
//            print("Identified and marked floor node: \(floorNode)")
//        } else {
//            print("Floor node not found")
//        }
//    }
//    
//    func placeObjectsFromBDM(filePath: String) {
//        guard let transforms = parser.parse(filePath: filePath),
//              let floorTransform = floorDetector.identifyFloorPosition(from: transforms) else {
//            print("Failed to parse BDM file or identify floor position")
//            return
//        }
//        
//        print("Parsed BDM file and identified floor position: \(floorTransform)")
//        
//        let floorSize = CGSize(width: 10, height: 10) // Example size, adjust as needed
//        let redPlaneNode = createRedPlaneNode(size: floorSize)
//        redPlaneNode.position = SCNVector3(floorTransform.columns.3.x, floorTransform.columns.3.y, floorTransform.columns.3.z)
//        parent.sceneView.scene.rootNode.addChildNode(redPlaneNode)
//        print("Placed red plane node at floor position: \(redPlaneNode.position)")
//    }
//    
//    private func createRedPlaneNode(size: CGSize) -> SCNNode {
//        let planeGeometry = SCNPlane(width: size.width, height: size.height)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//        planeGeometry.materials = [material]
//        let planeNode = SCNNode(geometry: planeGeometry)
//        planeNode.eulerAngles.x = -.pi / 2 // Rotate the plane to be horizontal
//        print("Created red plane node of size: \(size)")
//        return planeNode
//    }
//}
//
