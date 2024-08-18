//
//  NavigationService.swift
//  Mapzin
//
//  Created by Amir Malamud on 21/07/2024.
//

//
//  NavigationService.swift
//  Mapzin
//
//  Created by Amir Malamud on 21/07/2024.
//

import ARKit
import SwiftUI

struct ARObject {
    let name: String
    var position: SCNVector3
    let color: UIColor
}

class NavigationService {
    private var qrCodeTransform: simd_float4x4?
    private var arObjects: [ARObject] = 
    [
        ARObject(name: "Opening1", position: SCNVector3(-0.174, -0.441, -0.382), color: .green),
        ARObject(name: "Door0", position: SCNVector3(2.08, -0.576, -0.079), color: .blue),
        ARObject(name: "Door3", position: SCNVector3(0.253, -0.537, 0.801), color: .blue),
        ARObject(name: "Wall13", position: SCNVector3(2.446, -0.537, -2.119), color: .blue),
        ARObject(name: "Door2", position: SCNVector3(-0.474, -0.537, 0.811), color: .blue),
        ARObject(name: "Door20", position: SCNVector3(-3.176, -0.537, 1.163), color: .blue),
        ARObject(name: "Opening3", position: SCNVector3(-3.415, -0.537, -3.777), color: .blue),
        ARObject(name: "Refrigerator0", position: SCNVector3(-6.7, -0.537, -3.774), color: .blue),
        ARObject(name: "Door1", position: SCNVector3(0.293, -0.537, -1.223), color: .blue),
        ARObject(name: "Window0", position: SCNVector3(-7.766, -0.537, -0.96), color: .blue),
    ]
    
    private let scaleFactor: Float = 1.0
    private var redCubeNode: SCNNode?
    private var objectNodes: [String: SCNNode] = [:]
    private let arrowSpacing: Float = 0.3 // Space between arrows in meters
    private let fixedHeight: Float = -1.4 // Fixed height for all cubes
    private let qrCodePosition = SCNVector3(-0.705, -0.376, -2.601)

    func handleAnchorDetection(anchor: ARImageAnchor, arView: ARSCNView?) -> SCNVector3? {
            guard let referenceImageName = anchor.referenceImage.name, referenceImageName == "Opening0" else {
                return nil
            }
            
            qrCodeTransform = anchor.transform
            
            print("1. QR Code position (fixed): \(qrCodePosition)")
            
            if let arView = arView {
                let userPosition = addRedCubeAtUserPosition(arView)
                
                let userRelativePosition = userPosition - qrCodePosition
                print("2. User position relative to QR: \(userRelativePosition)")
                
                // Fix ARObject positions relative to user position
                fixARObjectPositions(userPosition: userPosition)
                
                addObjectCubes(in: arView)
           //     createSequentialRoute(in: arView, startingFrom: userPosition)
                
                // Print ARObject positions relative to user position
                for object in arObjects {
                    if let objectNode = objectNodes[object.name] {
                        let objectRelativePosition = objectNode.position - userPosition
                        print("3. \(object.name) position relative to user: \(objectRelativePosition)")
                    }
                }
            }
            
            return qrCodePosition
        }
    private func fixARObjectPositions(userPosition: SCNVector3) {
            for i in 0..<arObjects.count {
                let relativePosition = arObjects[i].position - qrCodePosition
                arObjects[i].position = userPosition + relativePosition
            }
        }

    private func createSequentialRoute(in arView: ARSCNView, startingFrom redCubePosition: SCNVector3) {
        var previousPosition = redCubePosition
        
        for object in arObjects {
            guard let objectNode = objectNodes[object.name] else { continue }
            presentRoute(in: arView, from: previousPosition, to: objectNode.position)
            previousPosition = objectNode.position
        }
    }

    private func addObjectCubes(in arView: ARSCNView) {
            for object in arObjects {
                let cubeNode = createCube(color: object.color)
                cubeNode.position = object.position
                cubeNode.position.y = fixedHeight
                cubeNode.name = object.name
                arView.scene.rootNode.addChildNode(cubeNode)
                objectNodes[object.name] = cubeNode
                
                print("Placed \(object.name) at position: \(cubeNode.position)")
            }
        }

    private func scalePosition(_ position: SCNVector3) -> SCNVector3 {
        return SCNVector3(position.x * scaleFactor, position.y, position.z * scaleFactor)
    }
    
    private func createDirectionArrows(in arView: ARSCNView, from start: SCNVector3, to end: SCNVector3) {
        let vector = end - start
        let distance = vector.length()
        let direction = vector.normalized()
        let arrowCount = Int(distance / arrowSpacing)

        for i in 1..<arrowCount {
            let offset = arrowSpacing * 1.05 // Adjust this multiplier to increase/decrease spacing
            let position = start + direction * Float(i) * offset
            
            if let arrowNode = SCNScene(named: "Direction_Arrow.scn")?.rootNode.childNodes.first {
                arrowNode.position = position
                arrowNode.look(at: end)
                
                arrowNode.scale = SCNVector3(0.0007, 0.0007, 0.0007)
                arrowNode.name = "routeArrow"
                
                arView.scene.rootNode.addChildNode(arrowNode)
            }
        }
    }

    func presentRoute(in arView: ARSCNView, from start: SCNVector3, to end: SCNVector3) {
        createDirectionArrows(in: arView, from: start, to: end)
        let vector = end - start
        let distance = vector.length()

        print("Route:")
        print("Start: \(start)")
        print("End: \(end)")
        print("Vector: \(vector)")
        print("Distance: \(String(format: "%.2f", distance)) meters")
    }

    private func addRedCubeAtUserPosition(_ arView: ARSCNView) -> SCNVector3 {
        guard let camera = arView.session.currentFrame?.camera else {
            print("Camera not available")
            return SCNVector3Zero
        }
        
        let cubeNode = createCube(color: .red)
        let cubePosition = SCNVector3(camera.transform.columns.3.x, fixedHeight, camera.transform.columns.3.z)
        
        cubeNode.position = cubePosition
        arView.scene.rootNode.addChildNode(cubeNode)
        redCubeNode = cubeNode
        
        print("Red cube placed at camera position: \(cubePosition)")
        return cubePosition
    }

    private func createCube(color: UIColor) -> SCNNode {
        let cubeGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let cubeMaterial = SCNMaterial()
        cubeMaterial.diffuse.contents = color
        cubeGeometry.materials = [cubeMaterial]
        return SCNNode(geometry: cubeGeometry)
    }

    func addObject(_ object: ARObject) {
        arObjects.append(object)
        print("Added object: \(object.name)")
    }

    func removeObject(named name: String) {
        arObjects.removeAll { $0.name == name }
        objectNodes[name]?.removeFromParentNode()
        objectNodes.removeValue(forKey: name)
        print("Removed object: \(name)")
    }

    func getObjects() -> [ARObject] {
        return arObjects
    }

    func updateRoute(in arView: ARSCNView) {
        // Remove existing route and object nodes
        arView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "routeArrow" || objectNodes.values.contains(node) {
                node.removeFromParentNode()
            }
        }
        objectNodes.removeAll()

        // Create new route
        if let redCube = redCubeNode {
            var previousPosition = redCube.position
            
            for object in arObjects {
                let objectNode = createObjectNode(for: object)
                arView.scene.rootNode.addChildNode(objectNode)
                objectNodes[object.name] = objectNode
                
                presentRoute(in: arView, from: previousPosition, to: objectNode.position)
                previousPosition = objectNode.position
            }
        }
        
        print("Route updated with \(arObjects.count) objects")
    }

    private func createObjectNode(for object: ARObject) -> SCNNode {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        node.geometry?.firstMaterial?.diffuse.contents = object.color
        node.position = object.position
        node.name = object.name
        return node
    }

    private func generateDirections(from camPosition: SCNVector3, to targetPosition: SCNVector3, distance: Float) -> String {
        let deltaX = targetPosition.x - camPosition.x
        let deltaY = targetPosition.y - camPosition.y
        let deltaZ = targetPosition.z - camPosition.z

        var directions = ""
        let stepSize: Float = 0.1

        if abs(deltaX) > stepSize {
            directions += deltaX > 0 ? "Move Right " : "Move Left "
        }
        if abs(deltaY) > stepSize {
            directions += deltaY > 0 ? "Move Up " : "Move Down "
        }
        if abs(deltaZ) > stepSize {
            directions += deltaZ > 0 ? "Move Forward " : "Move Backward "
        }

        directions += String(format: "for %.2f meters", distance)
        return directions
    }
}
