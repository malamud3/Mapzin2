//
//  ARView.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.
//

import SwiftUI
import ARKit

struct ARView: View {
    let buildingName: String
    
    var body: some View {
        ARSceneView()
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("AR View for \(buildingName)", displayMode: .inline)
    }
}

struct ARSceneView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        
        // Create a basic AR scene
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Add a node (e.g., a simple cube) to the scene
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        cubeNode.position = SCNVector3(0, 0, -0.5) // Place the cube in front of the camera
        scene.rootNode.addChildNode(cubeNode)
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // No updates needed here
    }
}

struct ARView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ARView(buildingName: "Example Building")
        }
    }
}
