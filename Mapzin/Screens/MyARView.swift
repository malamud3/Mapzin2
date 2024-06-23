//
//  ARView.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.
//

import SwiftUI
import ARKit

struct MyARView: View {
    let buildingName: String
    
    var body: some View {
        ARSceneView()
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("AR View for \(buildingName)", displayMode: .inline)
    }
}

struct ARSceneView: UIViewRepresentable {
    let sceneView = ARSCNView()
    var selectedModel: String? = "cube" // Default model is a cube
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        sceneView.delegate = context.coordinator
        
        // Create a basic AR scene
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Add a default node (e.g., a cube) to the scene
        updateARScene()
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Update the AR scene if selectedModel changes
        updateARScene()
    }
    
    private func updateARScene() {
        sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        
        if let modelName = selectedModel {
            var geometry: SCNGeometry
            
            switch modelName {
            case "cube":
                geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            case "sphere":
                geometry = SCNSphere(radius: 0.1)
            default:
                geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            }
            
            let node = SCNNode(geometry: geometry)
            node.position = SCNVector3(0, 0, -0.5) // Place the object in front of the camera
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARSceneView
        
        init(_ parent: ARSceneView) {
            self.parent = parent
        }
    }
}


