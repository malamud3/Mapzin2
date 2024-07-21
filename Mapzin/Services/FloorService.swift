//
//  FloorDetectionService.swift
//  Mapzin
//
//  Created by Amir Malamud on 10/07/2024.
//

import ARKit

class FloorService: NSObject, ARSCNViewDelegate {
    var floorAnchor: ARPlaneAnchor?
    var floorNode: SCNNode?
    var onFloorDetected: ((ARPlaneAnchor) -> Void)?
    
    func setupFloorDetection(for arView: ARSCNView) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
        arView.delegate = self
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        floorAnchor = planeAnchor
        floorNode = createFloorNode(anchor: planeAnchor)
        node.addChildNode(floorNode!)
        
        onFloorDetected?(planeAnchor)
    }
    
    private func createFloorNode(anchor: ARPlaneAnchor) -> SCNNode {
        let floorGeometry = SCNPlane(width: CGFloat(anchor.center.x), height: CGFloat(anchor.center.z))
        floorGeometry.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.5)
        let floorNode = SCNNode(geometry: floorGeometry)
        floorNode.eulerAngles.x = -.pi / 2
        return floorNode
    }
}
