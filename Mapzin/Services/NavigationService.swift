//
//  NavigationService.swift
//  Mapzin
//
//  Created by Amir Malamud on 15/07/2024.
//

import ARKit
import SceneKit

class NavigationService {
    private var navigationNodes: [SCNNode] = []
    private var currentPath: [SCNVector3] = []
    
    func planPath(from start: SCNVector3, to destination: SCNVector3, obstacles: [SCNNode]) -> [SCNVector3] {
        // Implement path planning algorithm here
        // For simplicity, we'll just return a straight line path
        // In a real app, you'd use A* or another pathfinding algorithm
        return [start, destination]
    }
    
    func displayPath(in sceneView: ARSCNView, path: [SCNVector3]) {
        clearPath()
        
        for i in 0..<path.count - 1 {
            let start = path[i]
            let end = path[i + 1]
            
            let node = createPathNode(from: start, to: end)
            sceneView.scene.rootNode.addChildNode(node)
            navigationNodes.append(node)
        }
        
        currentPath = path
    }
    
    private func createPathNode(from start: SCNVector3, to end: SCNVector3) -> SCNNode {
        let vector = SCNVector3(end.x - start.x, end.y - start.y, end.z - start.z)
        let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        
        let cylinder = SCNCylinder(radius: 0.02, height: CGFloat(distance))
        cylinder.firstMaterial?.diffuse.contents = UIColor.blue
        
        let node = SCNNode(geometry: cylinder)
        node.position = SCNVector3(
            (start.x + end.x) / 2,
            (start.y + end.y) / 2,
            (start.z + end.z) / 2
        )
        
        node.eulerAngles = SCNVector3(
            Float.pi / 2 - acos((end.y - start.y) / distance),
            0,
            atan2(end.z - start.z, end.x - start.x)
        )
        
        return node
    }
    
    func clearPath() {
        for node in navigationNodes {
            node.removeFromParentNode()
        }
        navigationNodes.removeAll()
        currentPath.removeAll()
    }
    
    func getNextInstruction(userPosition: SCNVector3) -> String {
        guard let nextPoint = currentPath.first else {
            return "You have reached your destination."
        }
        
        let distance = distance(from: userPosition, to: nextPoint)
        let direction = direction(from: userPosition, to: nextPoint)
        
        return "Move \(direction) for approximately \(String(format: "%.1f", distance)) meters."
    }
    
    private func distance(from: SCNVector3, to: SCNVector3) -> Float {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let dz = to.z - from.z
        return sqrt(dx*dx + dy*dy + dz*dz)
    }
    
    private func direction(from: SCNVector3, to: SCNVector3) -> String {
        let dx = Double(to.x - from.x)
        let dz = Double(to.z - from.z)
        let angle = atan2(dz, dx)
        
        switch angle {
        case -Double.pi/4...Double.pi/4:
            return "right"
        case Double.pi/4...3*Double.pi/4:
            return "forward"
        case -3*Double.pi/4 ... -Double.pi/4:
            return "backward"
        default:
            return "left"
        }
    }
}
