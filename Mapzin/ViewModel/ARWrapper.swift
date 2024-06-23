//
//  ARWrapper.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SwiftUI
import ARKit

struct ARWrapper: UIViewRepresentable {
    
    let arView = ARSCNView(frame: .zero)
    let bdmManager = BdmManagerData() // Initialize BDM manager
    
    func makeUIView(context: Context) -> ARSCNView {
        let configuration = buildConfiguration()
        arView.debugOptions = [.showFeaturePoints, .showWorldOrigin, .showBoundingBoxes]
        arView.session.run(configuration)
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Update the AR view if needed
    }
    
    private func buildConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.environmentTexturing = .automatic
        configuration.sceneReconstruction = .meshWithClassification
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics = .sceneDepth
        }
        return configuration
    }
    
    // Function to place objects in AR based on BDM data
    func placeObjectsFromBDM(filePath: String) {
        if let roomScanData = bdmManager.readBDMFile(filePath: filePath) {
            for room in roomScanData.rooms {
                for object in room.objects {
                    let objectNode = SCNNode()
                    // Assuming object.name is the name of the object to place
                    // and object.position is the position from BDM file
                    objectNode.position = SCNVector3(object.position.x, object.position.y, object.position.z)
                    // Add your custom logic to load the object and add it to the scene
                    // Example:
                    // let objectScene = SCNScene(named: object.name)
                    // objectNode.addChildNode(objectScene.rootNode)
                    arView.scene.rootNode.addChildNode(objectNode)
                }
            }
        }
    }
}

    
//    private func placeARAnchor(in arView: ARSCNView, at roomScanData: RoomScanData) {
//        // Convert room scan data coordinates to SCNVector3
//        let anchorPosition = roomScanData // Assuming roomScanData already contains coordinates
//        
//        // Create a translation matrix to represent the anchor's position
//        var translation = matrix_identity_float4x4
//        translation.columns.3.x = anchorPosition.x
//        translation.columns.3.y = anchorPosition.y
//        translation.columns.3.z = anchorPosition.z
//        
//        // Create an ARAnchor using the translation matrix
//        let anchor = ARAnchor(transform: translation)
//        
//        // Add the anchor to the AR session
//        arView.session.add(anchor: anchor)
//    }
//}
