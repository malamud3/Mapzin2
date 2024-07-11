//
//  POIService.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import ARKit

class POIService {
    func getSamplePOIs() -> [POI] {
        let poi1 = POI(
            id: UUID(),
            name: "Classroom 101",
            description: "A sample classroom",
            category: "Classroom",
            position: Position(x: 0.5, y: 0.0, z: -1.0),
            buildingID: UUID(),
            levelID: UUID()
        )
        // Add more sample POIs if needed
        return [poi1]
    }
    
    func createPOINode(for poi: POI) -> SCNNode {
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial?.diffuse.contents = UIColor.blue
        
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(poi.position.x, poi.position.y, poi.position.z)
        node.name = poi.name
        
        return node
    }
    
    func addPOIsToScene(pois: [POI], sceneView: ARSCNView) {
        for poi in pois {
            let poiNode = createPOINode(for: poi)
            sceneView.scene.rootNode.addChildNode(poiNode)
        }
    }
}
