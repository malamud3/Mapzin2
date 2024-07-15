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

        if planeAnchor.alignment == .horizontal && floorAnchor == nil {
            self.floorAnchor = planeAnchor
            self.floorNode = node
            print("Detected floor at \(planeAnchor.center)")

            let floorGeometry = SCNPlane(width: CGFloat(planeAnchor.center.x), height: CGFloat(planeAnchor.center.z))
            let floorMaterial = SCNMaterial()
            floorMaterial.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
            floorGeometry.materials = [floorMaterial]

            let floorPlane = SCNNode(geometry: floorGeometry)
            floorPlane.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            floorPlane.eulerAngles.x = -.pi / 2

            node.addChildNode(floorPlane)
            onFloorDetected?(planeAnchor)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
              let floorNode = self.floorNode,
              anchor == self.floorAnchor else { return }

        if let planeGeometry = floorNode.geometry as? SCNPlane {
            planeGeometry.width = CGFloat(planeAnchor.center.x)
            planeGeometry.height = CGFloat(planeAnchor.center.z)
            floorNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        }
    }
}
