//
//  ARObjectDetectionService.swift
//  Mapzin
//
//  Created by Amir Malamud on 11/07/2024.
//

import ARKit

class ARObjectDetectionService {
    private var pois: [UUID: POI] = [:]
    
    func addPOI(_ poi: POI, to arView: ARSCNView) {
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        boxNode.position = SCNVector3(poi.position.x, poi.position.y, poi.position.z)
        boxNode.name = poi.id.uuidString
        arView.scene.rootNode.addChildNode(boxNode)
        pois[poi.id] = poi
    }
    
    func getPOI(by id: UUID) -> POI? {
        return pois[id]
    }
    
    func getPOINode(by id: UUID, from arView: ARSCNView) -> SCNNode? {
        return arView.scene.rootNode.childNode(withName: id.uuidString, recursively: false)
    }
    
    func calculate2DAngleAndVerticalPosition(to node: SCNNode, from cameraTransform: simd_float4x4) -> (Float, String) {
        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        let nodePosition = node.position
        
        // Project the positions onto the horizontal plane (ignore the y-axis)
        let cameraPosition2D = SCNVector3(cameraPosition.x, 0, cameraPosition.z)
        let nodePosition2D = SCNVector3(nodePosition.x, 0, nodePosition.z)
        let vectorToNode = SCNVector3(nodePosition2D.x - cameraPosition2D.x, 0, nodePosition2D.z - cameraPosition2D.z)
        
        // Normalize vectors
        let cameraForward = SCNVector3(-cameraTransform.columns.2.x, 0, -cameraTransform.columns.2.z)
        let normalizedVectorToNode = normalize(vectorToNode)
        let normalizedCameraForward = normalize(cameraForward)
        
        // Calculate dot product
        let dotProduct = dot(normalizedVectorToNode, normalizedCameraForward)
        let angle = acos(dotProduct) * (180.0 / .pi) // Convert to degrees
        
        // Determine vertical position
        let verticalPosition = cameraPosition.y > nodePosition.y ? "above" : "below"
        
        return (angle, verticalPosition)
    }
    
    private func normalize(_ vector: SCNVector3) -> SCNVector3 {
        let length = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        return SCNVector3(vector.x / length, vector.y / length, vector.z / length)
    }
    
    private func dot(_ vector1: SCNVector3, _ vector2: SCNVector3) -> Float {
        return vector1.x * vector2.x + vector1.z * vector2.z
    }
}
