//////
//////  ARService.swift
//////  Mapzin
//////
//////  Created by Amir Malamud on 10/07/2024.
//////
////
////import ARKit
////
////class ARService: NSObject, ARSCNViewDelegate {
////    private var sceneView: ARSCNView?
////
////
////    func setupARScene(sceneView: ARSCNView) {
////        self.sceneView = sceneView
////        sceneView.delegate = self
////        
//////        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//////        sceneView.addGestureRecognizer(tapGestureRecognizer)
////        
////        // Disable auto focus behavior if not needed
////        sceneView.autoenablesDefaultLighting = true
////        sceneView.automaticallyUpdatesLighting = true
////        
////        // Add coaching overlay
////        let coachingOverlay = ARCoachingOverlayView()
////        coachingOverlay.session = sceneView.session
////        coachingOverlay.activatesAutomatically = true
////        coachingOverlay.goal = .horizontalPlane
////        sceneView.addSubview(coachingOverlay)
////
////    }
////    private func prepareScene() {
////            guard let sceneView = sceneView else { return }
////
////            SCNTransaction.begin()
////            SCNTransaction.disableActions = true
////
////            // Add your scene setup code here
////            // e.g., loading models, setting up nodes
////
////            SCNTransaction.commit()
////
////            DispatchQueue.main.async {
////                sceneView.isHidden = false
////            }
////        }
//////    @objc private func handleTap(_ gestureRecognize: UIGestureRecognizer) {
//////        guard let sceneView = sceneView else { return }
//////        let touchLocation = gestureRecognize.location(in: sceneView)
//////        
//////        guard let query = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any) else {
//////            return
//////        }
//////        
//////        let results = sceneView.session.raycast(query)
//////        
//////        if let hitResult = results.first {
//////            let position = hitResult.worldTransform.columns.3
//////            let poiPosition = Position(x: position.x, y: position.y, z: position.z)
//////            let poi = POI(id: UUID(), name: "Room Door", description: "The door to my room", category: "Door", position: poiPosition, buildingID: UUID(), levelID: UUID())
//////            print("Hit Position: \(position)")
//////            print("POI Position: \(poiPosition)")
//////            addPOI(poi, to: sceneView)
//////        } else {
//////            print("No hit result found.")
//////        }
//////    }
////    
////    private func addPOI(_ poi: POI, to sceneView: ARSCNView) {
////        let sphere = SCNSphere(radius: 0.05)
////        sphere.firstMaterial?.diffuse.contents = UIColor.red
////        
////        let node = SCNNode(geometry: sphere)
////        node.position = SCNVector3(poi.position.x, poi.position.y, poi.position.z)
////        node.name = poi.name
////        
////        sceneView.scene.rootNode.addChildNode(node)
////    }
////    
////    func createARConfiguration() -> ARWorldTrackingConfiguration {
////        let configuration = ARWorldTrackingConfiguration()
////        configuration.planeDetection = [.horizontal, .vertical]
////        return configuration
////    }
////}
//import ARKit
//
//class ARService: NSObject, ARSCNViewDelegate {
//    private var sceneView: ARSCNView?
//
//    func setupARScene(sceneView: ARSCNView) {
//        self.sceneView = sceneView
//        sceneView.delegate = self
//        
////        // Disable auto focus behavior if not needed
////        sceneView.autoenablesDefaultLighting = true
////        sceneView.automaticallyUpdatesLighting = true
//        
////        // Add coaching overlay
////        let coachingOverlay = ARCoachingOverlayView()
////        coachingOverlay.session = sceneView.session
////        coachingOverlay.activatesAutomatically = true
////        coachingOverlay.goal = .horizontalPlane
////        sceneView.addSubview(coachingOverlay)
//    }
//
//    private func prepareScene() {
//        guard let sceneView = sceneView else { return }
//
//        SCNTransaction.begin()
//        SCNTransaction.disableActions = true
//
//        // Add your scene setup code here
//        // e.g., loading models, setting up nodes
//
//        SCNTransaction.commit()
//
//        DispatchQueue.main.async {
//            sceneView.isHidden = false
//        }
//    }
//    
//    private func addPOI(_ poi: POI, to sceneView: ARSCNView) {
//        let sphere = SCNSphere(radius: 0.05)
//        sphere.firstMaterial?.diffuse.contents = UIColor.red
//        
//        let node = SCNNode(geometry: sphere)
//        node.position = SCNVector3(poi.position.x, poi.position.y, poi.position.z)
//        node.name = poi.name
//        
//        sceneView.scene.rootNode.addChildNode(node)
//    }
//    
//    func createARConfiguration() -> ARWorldTrackingConfiguration {
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal, .vertical]
//        configuration.environmentTexturing = .automatic
//        return configuration
//    }
//}
