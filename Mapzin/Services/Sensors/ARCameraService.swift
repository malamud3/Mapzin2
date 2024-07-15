//
//  ARCameraService.swift
//  Mapzin
//
//  Created by Amir Malamud on 11/07/2024.
//

import ARKit

class ARCameraService {
    private var lastPosition: SCNVector3?
    
    func updateCameraPosition(frame: ARFrame) {
        let cameraTransform = frame.camera.transform
        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        
        if let lastPosition = lastPosition {
            let movement = abs(cameraPosition.x - lastPosition.x) + abs(cameraPosition.y - lastPosition.y) + abs(cameraPosition.z - lastPosition.z)
            if movement < 0.1 {
                return // No significant movement
            }
        }
        
        lastPosition = cameraPosition
        let formattedPosition = SCNVector3(round(cameraPosition.x * 1000) / 1000, round(cameraPosition.y * 1000) / 1000, round(cameraPosition.z * 1000) / 1000)
//        print("Camera Position: \(formattedPosition)")
    }
    
    func calculateDistances(to node: SCNNode, from arView: ARSCNView) -> (total: Float, x: Float, y: Float, z: Float) {
        guard let cameraTransform = arView.session.currentFrame?.camera.transform else { return (0, 0, 0, 0) }
        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        let nodePosition = node.position
        let distanceX = nodePosition.x - cameraPosition.x
        let distanceY = nodePosition.y - cameraPosition.y
        let distanceZ = nodePosition.z - cameraPosition.z
        let totalDistance = sqrt(pow(distanceX, 2) + pow(distanceY, 2) + pow(distanceZ, 2))
        return (totalDistance, distanceX, distanceY, distanceZ)
    }
}
