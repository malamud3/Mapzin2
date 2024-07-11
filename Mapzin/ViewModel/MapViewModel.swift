////
////  MapViewModel.swift
////  Mapzin
////
////  Created by Amir Malamud on 10/07/2024.
////
//
//
////import SwiftUI
////import ARKit
////
////class MapViewModel: ObservableObject {
////    
////    @Published var floorMap: FloorMap
////    @Published var buildings: [Building] = []
////    @Published var pois: [POI] = []
////    
////    @Published var isPlaneDetected = false
////    @Published var detectedPlanes: [ARPlaneAnchor] = []
////    private let arSession = ARSession()
////    
////    
////    private let arService: ARService
////    private let poiService: POIService
////    private let floorService: FloorService
////    private let bdmService: BDMService
////    private var sceneView: ARSCNView?
////    
////    init(arService: ARService, poiService: POIService, floorService: FloorService, bdmService: BDMService) {
////        self.arService = arService
////        self.poiService = poiService
////        self.floorService = floorService
////        self.bdmService = bdmService
////        self.floorMap = FloorMap(fileName: "Primary_bdm.scn")
////        
////        // Add sample POIs
////        pois = poiService.getSamplePOIs()
////    }
////    
////    func setupARScene(sceneView: ARSCNView) {
////        self.sceneView = sceneView
////        let configuration = arService.createARConfiguration()
////        sceneView.session.run(configuration)
////        loadScene()
////    }
////    
////    private func loadScene() {
////        guard sceneView != nil else {
////                print("Failed to load the scene")
////                return
////            }
////            // Commenting out the BDM file loading logic
////            /*
////            guard let scene = SCNScene(named: "Primary_bdm.scn") else {
////                print("Failed to load the scene")
////                return
////            }
////            sceneView.scene = scene
////            floorService.identifyAndMarkFloor(in: scene)
////            */
////        }
////    
////    func addPOIsToScene() {
////        guard let sceneView = sceneView else { return }
////        poiService.addPOIsToScene(pois: pois, sceneView: sceneView)
////    }
////    
////    func placeObjectsFromBDM(filePath: String) {
////        guard let transforms = bdmService.parseBDMFile(filePath: filePath) else {
////            print("Failed to parse BDM file")
////            return
////        }
////        
////        for transform in transforms {
////            let node = SCNNode()
////            node.simdTransform = transform
////            sceneView?.scene.rootNode.addChildNode(node)
////        }
////    }
////    
////    func updateDetectedPlanes(_ anchors: [ARAnchor]) {
////          detectedPlanes = anchors.compactMap { $0 as? ARPlaneAnchor }
////          isPlaneDetected = !detectedPlanes.isEmpty
////      }
////}
//import SwiftUI
//import ARKit
//
//class MapViewModel: ObservableObject {
//    @Published var floorMap: FloorMap
//    @Published var buildings: [Building] = []
//    @Published var pois: [POI] = []
//    
//    @Published var isPlaneDetected = false
//    @Published var detectedPlanes: [ARPlaneAnchor] = []
//    @Published var arStatus: String = "Initializing AR..."
//    
//    private let arService: ARService
//    private let poiService: POIService
//    private let floorService: FloorService
//    private let bdmService: BDMService
//    private var sceneView: ARSCNView?
//    
//    init(arService: ARService, poiService: POIService, floorService: FloorService, bdmService: BDMService) {
//        self.arService = arService
//        self.poiService = poiService
//        self.floorService = floorService
//        self.bdmService = bdmService
//        self.floorMap = FloorMap(fileName: "Primary_bdm.scn")
//        
//        // Add sample POIs
//        pois = poiService.getSamplePOIs()
//    }
//    
//    func setupARScene(sceneView: ARSCNView) {
//        self.sceneView = sceneView
//        let configuration = arService.createARConfiguration()
//        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//        
//        // Debugging output to check session state
//        print("AR session started")
//    }
//    
//    private func loadScene() {
//        guard sceneView != nil else {
//            print("Failed to load the scene")
//            return
//        }
//        // Your scene loading logic here
//    }
//    
//    func addPOIsToScene() {
//        guard let sceneView = sceneView else { return }
//        poiService.addPOIsToScene(pois: pois, sceneView: sceneView)
//    }
//    
//    func placeObjectsFromBDM(filePath: String) {
//        guard let transforms = bdmService.parseBDMFile(filePath: filePath) else {
//            print("Failed to parse BDM file")
//            return
//        }
//        
//        for transform in transforms {
//            let node = SCNNode()
//            node.simdTransform = transform
//            sceneView?.scene.rootNode.addChildNode(node)
//        }
//    }
//    
//    func updateDetectedPlanes(_ anchors: [ARAnchor]) {
//        detectedPlanes = anchors.compactMap { $0 as? ARPlaneAnchor }
//        isPlaneDetected = !detectedPlanes.isEmpty
//    }
//    
//    func updateARStatus(for frame: ARFrame) {
//        switch frame.camera.trackingState {
//        case .normal:
//            arStatus = "AR tracking normal"
//        case .limited(.excessiveMotion):
//            arStatus = "Too much motion - slow down"
//        case .limited(.insufficientFeatures):
//            arStatus = "Not enough features - aim at a textured surface"
//        case .limited(.initializing):
//            arStatus = "Initializing AR..."
//        case .limited(_):
//            arStatus = "Limited tracking"
//        case .notAvailable:
//            arStatus = "Tracking not available"
//        }
//    }
//}
