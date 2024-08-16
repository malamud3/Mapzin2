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
    let position: SCNVector3
    let color: UIColor
}

class NavigationService {
    private var qrCodeTransform: simd_float4x4?
    private var arObjects: [ARObject] = []
    private let scaleFactor: Float = 1.0
    private var redCubeNode: SCNNode?
    private var objectNodes: [String: SCNNode] = [:]
    private var vectorData: [String: SCNVector3] = [:]
    private let arrowSpacing: Float = 0.3 // Space between arrows in meters

    init() {
        arObjects = [
            ARObject(name: "Door0", position: SCNVector3(-0.568, -0.478, -1.851), color: .green),
            ARObject(name: "Window0", position: SCNVector3(-0.8, -0.478, 0.622), color: .blue),
        ]
    }

    func handleAnchorDetection(anchor: ARImageAnchor, arView: ARSCNView?) -> SCNVector3? {
        let referenceImageName = anchor.referenceImage.name
        print("Detected marker with name: \(referenceImageName ?? "Unknown")")
        
        if referenceImageName == "Opening0" {
            qrCodeTransform = anchor.transform
            
            if let arView = arView {
                let redCubePosition = addRedCubeAtUserPosition(arView)
                addObjectCubes(in: arView, qrTransform: anchor.transform)
                createDirectionArrows(in: arView)
                calculateVectorData()
            }
            
            return SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
        }
        return nil
    }
    
    private func createDirectionArrows(in arView: ARSCNView) {
        guard let redCube = redCubeNode else { return }
        
        for (name, objectNode) in objectNodes {
            let vector = SCNVector3(
                objectNode.position.x - redCube.position.x,
                objectNode.position.y - redCube.position.y,
                objectNode.position.z - redCube.position.z
            )
            
            let distance = vector.length()
            let direction = vector.normalized()
            let arrowCount = Int(distance / arrowSpacing) // Halve the number of arrows
            let midHeight = (redCube.position.y + objectNode.position.y) / 2

            for i in 1..<arrowCount {
                let offset = arrowSpacing * 1.05 // Adjust this multiplier to increase/decrease spacing
                let position = SCNVector3(
                    redCube.position.x + direction.x * Float(i) * offset,
                    redCube.position.y + direction.y * Float(i) * offset,
                    redCube.position.z + direction.z * Float(i) * offset
                )
                
                if let arrowNode = SCNScene(named: "Direction_Arrow.scn")?.rootNode.childNodes.first {
                    arrowNode.position = position
                    arrowNode.look(at: objectNode.position)
                    
                    arrowNode.scale = SCNVector3(0.0007, 0.0007, 0.0007)
                    
                    arView.scene.rootNode.addChildNode(arrowNode)
                }
            }
        }
    }



    
    private func addRedCubeAtUserPosition(_ arView: ARSCNView) -> SCNVector3 {
            guard let camera = arView.pointOfView else { return SCNVector3Zero }
            
            let cubeNode = createCube(color: .red)
            
            let cameraPosition = camera.position
            let cameraTransform = camera.transform
            let cameraDirection = SCNVector3(
                -cameraTransform.m31,
                -cameraTransform.m32,
                -cameraTransform.m33
            )
            let cubePosition = SCNVector3(
                cameraPosition.x - cameraDirection.x * 0.2,
                cameraPosition.y - cameraDirection.y * 0.2,
                cameraPosition.z - cameraDirection.z * 0.2
            )
            cubeNode.position = cubePosition
            
            arView.scene.rootNode.addChildNode(cubeNode)
            redCubeNode = cubeNode
            return cubePosition
        }

    private func addObjectCubes(in arView: ARSCNView, qrTransform: simd_float4x4) {
           guard let redCube = redCubeNode else {
               print("Red cube not found. Cannot align other cubes.")
               return
           }

           for object in arObjects {
               let cubeNode = createCube(color: object.color)
               
               let scaledPosition = SCNVector3(
                   object.position.x * scaleFactor,
                   redCube.position.y, // Set y-coordinate to match red cube's height
                   object.position.z * scaleFactor
               )
               
               let translation = simd_float4x4(
                   simd_float4(1, 0, 0, 0),
                   simd_float4(0, 1, 0, 0),
                   simd_float4(0, 0, 1, 0),
                   simd_float4(scaledPosition.x, scaledPosition.y, scaledPosition.z, 1)
               )
               
               let combinedTransform = simd_mul(qrTransform, translation)
               
               cubeNode.simdTransform = combinedTransform
               
               cubeNode.name = object.name
               arView.scene.rootNode.addChildNode(cubeNode)
               objectNodes[object.name] = cubeNode
               
               print("Placed \(object.name) at position: \(cubeNode.position)")
           }
       }

        private func createCube(color: UIColor) -> SCNNode {
            let cubeGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            let cubeMaterial = SCNMaterial()
            cubeMaterial.diffuse.contents = color
            cubeGeometry.materials = [cubeMaterial]
            return SCNNode(geometry: cubeGeometry)
        }

        private func createConnectionLines(in arView: ARSCNView) {
            guard let redCube = redCubeNode else { return }
            
            for (name, objectNode) in objectNodes {
                let line = SCNGeometry.line(from: redCube.position, to: objectNode.position)
                let lineNode = SCNNode(geometry: line)
                arView.scene.rootNode.addChildNode(lineNode)
            }
        }

    func addObject(_ object: ARObject) {
        arObjects.append(object)
    }

    func removeObject(named name: String) {
        arObjects.removeAll { $0.name == name }
    }

    func getObjects() -> [ARObject] {
        return arObjects
    }

    private func calculateVectorData() {
            guard let redCube = redCubeNode else { return }
            
            for (name, objectNode) in objectNodes {
                let vector = SCNVector3(
                    objectNode.position.x - redCube.position.x,
                    objectNode.position.y - redCube.position.y,
                    objectNode.position.z - redCube.position.z
                )
                vectorData[name] = vector
                print("Vector to \(name): \(vector)")
            }
        }

        func getVectorData() -> [String: SCNVector3] {
            return vectorData
        }

    func handleCameraPositionUpdate(position: SCNVector3, qrCodeOrigin: SCNVector3?) -> SCNVector3? {
        if let origin = qrCodeOrigin {
            let relativePosition = SCNVector3(
                position.x - origin.x,
                position.y - origin.y,
                position.z - origin.z
            )
            print("Updated relative camera position: \(relativePosition)")
            return relativePosition
        }
        return nil
    }

//    func generateDoorNavigation(from camPosition: SCNVector3, qrOrigin: SCNVector3) -> String {
//        let doorRelativePosition = calculateRelativePosition(of: door0Position, from: qrOrigin)
//        let distanceToDoor = calculateDistance(from: camPosition, to: doorRelativePosition)
//        
//        if distanceToDoor < 0.5 {
//            return "You have reached Door0."
//        } else {
//            return generateDirections(from: camPosition, to: doorRelativePosition, distance: distanceToDoor)
//        }
//    }
//
//    func detectWindows(from qrOrigin: SCNVector3) -> [SCNVector3] {
//        let windowPositions = [window0Position] // Add more window positions here
//        return windowPositions.map { calculateRelativePosition(of: $0, from: qrOrigin) }
//    }

    private func generateDirections(from camPosition: SCNVector3, to targetPosition: SCNVector3, distance: Float) -> String {
        let deltaX = targetPosition.x - camPosition.x
        let deltaY = targetPosition.y - camPosition.y
        let deltaZ = targetPosition.z - camPosition.z
        
        var instructions = "Navigate to Door0: "
        
        if abs(deltaX) > 0.1 {
            instructions += deltaX > 0 ? "Move right. " : "Move left. "
        }

        if abs(deltaY) > 0.1 {
            instructions += deltaY > 0 ? "Move up. " : "Move down. "
        }

        if abs(deltaZ) > 0.1 {
            instructions += deltaZ > 0 ? "Move forward. " : "Move backward. "
        }

        instructions += "Distance: \(String(format: "%.2f", distance)) meters."
        
        return instructions
    }

    private func calculateRelativePosition(of targetPosition: SCNVector3, from originPosition: SCNVector3) -> SCNVector3 {
        return SCNVector3(
            targetPosition.x - originPosition.x,
            targetPosition.y - originPosition.y,
            targetPosition.z - originPosition.z
        )
    }

    private func calculateDistance(from startPosition: SCNVector3, to endPosition: SCNVector3) -> Float {
        let deltaX = endPosition.x - startPosition.x
        let deltaY = endPosition.y - startPosition.y
        let deltaZ = endPosition.z - startPosition.z
        
        return sqrt(pow(deltaX, 2) + pow(deltaY, 2) + pow(deltaZ, 2))
    }
}
extension SCNGeometry {
    class func line(from vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
}
extension SCNVector3 {
    func length() -> Float {
        return sqrt(x*x + y*y + z*z)
    }
    
    func normalized() -> SCNVector3 {
        let len = length()
        return len>0 ? self / len : SCNVector3Zero
    }
}

extension SCNVector3 {
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }
    
    static func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
}
