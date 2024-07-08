//
//  ARSceneView.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import ARKit
import SwiftUI

struct ARSceneView: UIViewRepresentable {
    @EnvironmentObject var mainCoordinator: Coordinator
    let sceneView = ARSCNView()
    var selectedModel: ModelType = .cube
    var modelPosition: SCNVector3? // Optional position
    var bdmFilePath: String? // Path to the BDM file
    
    func makeCoordinator() -> ARSceneCoordinator {
        ARSceneCoordinator(parent: self, parser: BDMParser(), floorDetector: FloorDetector(), stepCounterService: StepCounterService())
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        sceneView.delegate = context.coordinator
        sceneView.scene = SCNScene()
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        // Add tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Load the scene from the .scn file
        context.coordinator.loadScene()
        
        // Place objects from BDM file if provided
        if let bdmFilePath = bdmFilePath {
            context.coordinator.placeObjectsFromBDM(filePath: bdmFilePath)
        } else if let modelPosition = modelPosition {
            context.coordinator.updateARScene(with: selectedModel, at: modelPosition)
        }
        
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if let modelPosition = modelPosition {
            context.coordinator.updateARScene(with: selectedModel, at: modelPosition)
        }
    }
}
