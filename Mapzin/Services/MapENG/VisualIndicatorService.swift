//
//  VisualIndicatorService.swift
//  Mapzin
//
//  Created by Amir Malamud on 20/07/2024.
//


import ARKit
import SceneKit

class VisualIndicatorService {
    func addVisualIndicators(for nodes: [NodeData], origin: SCNVector3, to arView: ARSCNView) {
        for node in nodes {
            addVisualIndicator(for: node, origin: origin, to: arView)
        }
    }

    private func addVisualIndicator(for node: NodeData, origin: SCNVector3, to arView: ARSCNView) {
        let indicator: SCNNode
        
        switch node.type {
        case .door:
            indicator = createDoorIndicator()
        case .window:
            indicator = createWindowIndicator()
        case .room:
            indicator = createRoomIndicator()
        case .other:
            indicator = createDefaultIndicator()
        }
        
        let relativePosition = SCNVector3(
            node.position.x + origin.x,
            node.position.y + origin.y,
            node.position.z + origin.z
        )
        indicator.position = relativePosition
        indicator.name = node.name
        
        arView.scene.rootNode.addChildNode(indicator)
    }
    
    private func createDoorIndicator() -> SCNNode {
        let doorGeometry = SCNBox(width: 0.1, height: 0.2, length: 0.05, chamferRadius: 0)
        doorGeometry.firstMaterial?.diffuse.contents = UIColor.brown
        return SCNNode(geometry: doorGeometry)
    }
    
    private func createWindowIndicator() -> SCNNode {
        let windowGeometry = SCNBox(width: 0.2, height: 0.15, length: 0.02, chamferRadius: 0)
        windowGeometry.firstMaterial?.diffuse.contents = UIColor.lightGray
        return SCNNode(geometry: windowGeometry)
    }
    
    private func createRoomIndicator() -> SCNNode {
        let roomGeometry = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0.05)
        roomGeometry.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.5)
        return SCNNode(geometry: roomGeometry)
    }
    
    private func createDefaultIndicator() -> SCNNode {
        let defaultGeometry = SCNSphere(radius: 0.05)
        defaultGeometry.firstMaterial?.diffuse.contents = UIColor.gray
        return SCNNode(geometry: defaultGeometry)
    }

    func updateVisualIndicators(for nodes: [NodeData], origin: SCNVector3, in arView: ARSCNView) {
        removeAllIndicators(from: arView)
        addVisualIndicators(for: nodes, origin: origin, to: arView)
    }

    func removeAllIndicators(from arView: ARSCNView) {
        arView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name != nil {  // Only remove named nodes (our indicators)
                node.removeFromParentNode()
            }
        }
    }

    func updateIndicatorVisibility(_ isVisible: Bool, for nodeName: String, in arView: ARSCNView) {
        if let node = arView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            node.isHidden = !isVisible
        }

    }
}
