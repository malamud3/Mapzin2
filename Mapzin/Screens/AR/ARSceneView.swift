////
////  ARSceneView.swift
////  Mapzin
////
////  Created by Amir Malamud on 23/06/2024.
////
//
////import ARKit
////import SwiftUI
////
////struct ARSceneView: UIViewRepresentable {
////    @EnvironmentObject private var coordinator: Coordinator
////    @ObservedObject var viewModel: MapViewModel
////    
////    let sceneView = ARSCNView()
////    var selectedModel: ModelType = .cube
////    var modelPosition: SCNVector3? // Optional position
////    var bdmFilePath: String? // Path to the BDM file
////    
////    func makeUIView(context: Context) -> ARSCNView {
////        viewModel.setupARScene(sceneView: sceneView)
////        
//////        // Place objects from BDM file if provided
//////        if let bdmFilePath = bdmFilePath {
//////            viewModel.placeObjectsFromBDM(filePath: bdmFilePath)
//////        } else if modelPosition != nil {
//////            // Handle model position if needed
//////        }
////        
////        // Add POIs to the scene
//////        viewModel.addPOIsToScene()
////        
//// 
////        return sceneView
////    }
////    
////    func updateUIView(_ uiView: ARSCNView, context: Context) {
////        if modelPosition != nil {
////            // Handle updates if needed
////        }
////    }
////    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
////      viewModel.updateDetectedPlanes(anchors)
////    }
////    
////    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
////       viewModel.updateDetectedPlanes(anchors)
////    }
////    
////    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
////        viewModel.updateDetectedPlanes(session.currentFrame?.anchors ?? [])
////    }
////}
//import ARKit
//import SwiftUI
//
//struct ARSceneView: UIViewRepresentable {
//    @EnvironmentObject private var coordinator: Coordinator
//    @ObservedObject var viewModel: MapViewModel
//    
//    let sceneView = ARSCNView()
//    var selectedModel: ModelType = .cube
//    var modelPosition: SCNVector3?
//    var bdmFilePath: String?
//    
//    func makeUIView(context: Context) -> ARSCNView {
//        viewModel.setupARScene(sceneView: sceneView)
//        
//        // Add a simple box to ensure something is visible
//        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
//        boxNode.position = SCNVector3(0, 0, -0.5) // 0.5 meters in front of the camera
//        sceneView.scene.rootNode.addChildNode(boxNode)
//        
//        return sceneView
//    }
//    
//    func updateUIView(_ uiView: ARSCNView, context: Context) {
//        if modelPosition != nil {
//            // Handle updates if needed
//        }
//    }
//     
//        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//          viewModel.updateDetectedPlanes(anchors)
//        }
//        
//        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//            viewModel.updateDetectedPlanes(anchors)
//        }
//        
//        func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
//           viewModel.updateDetectedPlanes(session.currentFrame?.anchors ?? [])
//        }
//        
//        func session(_ session: ARSession, didFailWithError error: Error) {
//            // Handle session failures
//        }
//        
//        func sessionWasInterrupted(_ session: ARSession) {
//            // Handle session interruptions
//        }
//        
//        func sessionInterruptionEnded(_ session: ARSession) {
//            // Handle ended session interruptions
//        }
//    
//}
