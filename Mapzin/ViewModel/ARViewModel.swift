//
//  ARViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 08/07/2024.
//

//
//  ARViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 08/07/2024.
//

import SwiftUI
import ARKit

class ARViewModel: NSObject, ObservableObject, ARSessionDelegate {
    @Published var measurements: [(total: Float, x: Float, y: Float, z: Float)] = []
    private let arSessionService = ARSessionService()
    private let arObjectDetectionService = ARObjectDetectionService()
    private let arCameraService = ARCameraService()
    private var lastPosition: SCNVector3?

    override init() {
        super.init()
        arSessionService.delegate = self
    }
    
    func setupARView(_ arView: ARSCNView) {
        arSessionService.setupARView(arView)
        arObjectDetectionService.addBoxNode(to: arView)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let arView = arSessionService.arView else { return }
        let touchLocation = gestureRecognizer.location(in: arView)
        let hitTestResults = arView.hitTest(touchLocation, options: nil)
        
        if let result = hitTestResults.first(where: { $0.node.name == "boxNode" }) {
            let distances = arCameraService.calculateDistances(to: result.node, from: arView)
            measurements.append(distances)
            
            // Calculate and print distances
            print("Distance to the object: \(distances.total) meters")
            print("Distance along X: \(distances.x) meters")
            print("Distance along Y: \(distances.y) meters")
            print("Distance along Z: \(distances.z) meters")
            
            // Calculate and print 2D angle and vertical position
            if let frame = arView.session.currentFrame {
                let (horizontalAngle, verticalPosition) = arObjectDetectionService.calculate2DAngleAndVerticalPosition(to: result.node, from: frame.camera.transform)
                print(String(format: "2D Angle to object: %.3f degrees", horizontalAngle))
                print("The object is \(verticalPosition) the camera.")
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        arCameraService.updateCameraPosition(frame: frame)
    }
}
