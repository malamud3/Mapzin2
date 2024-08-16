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
    private let fixedHeight: Float = -1.4 // Fixed height for all cubes

    private let qrCodePosition = SCNVector3(0, -1.5, -2.5) // Updated Y to fixedHeight
    private let door0Position = SCNVector3(0.568, -1.4, -1.851) // Y is already at fixedHeight

    init() {
        // Calculate Door0 position relative to QR code
        let relativeDoor0Position = SCNVector3(
            door0Position.x - qrCodePosition.x,
            0, // Y difference is now 0
            door0Position.z - qrCodePosition.z
        )

        // Calculate Window0 position (1 meter away from Door0 in the same direction)
        let doorToQRVector = SCNVector3(
            qrCodePosition.x - door0Position.x,
            0, // Ignore Y difference
            qrCodePosition.z - door0Position.z
        )
        let normalizedVector = normalize(doorToQRVector)
        let window0Position = SCNVector3(
            door0Position.x + normalizedVector.x,
            fixedHeight,
            door0Position.z + normalizedVector.z
        )
        let relativeWindow0Position = SCNVector3(
            window0Position.x - qrCodePosition.x,
            0, // Y difference is now 0
            window0Position.z - qrCodePosition.z
        )

        arObjects = [
            ARObject(name: "Door0", position: relativeDoor0Position, color: .green),
            ARObject(name: "Window0", position: relativeWindow0Position, color: .blue),
        ]
    }

    private func normalize(_ vector: SCNVector3) -> SCNVector3 {
        let length = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        return SCNVector3(vector.x / length, vector.y / length, vector.z / length)
    }

    func handleAnchorDetection(anchor: ARImageAnchor, arView: ARSCNView?) -> SCNVector3? {
        let referenceImageName = anchor.referenceImage.name
        
        if referenceImageName == "Opening0" {
            qrCodeTransform = anchor.transform
            
            if let arView = arView {
                let redCubePosition = addRedCubeAtUserPosition(arView)
                addObjectCubes(in: arView, qrTransform: anchor.transform, redCubePosition: redCubePosition)
                if let firstObject = objectNodes.values.first {
                    createSequentialRoute(in: arView, startingFrom: redCubePosition)
                }
            }
            
            return SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
        }
        return nil
    }

    private func createSequentialRoute(in arView: ARSCNView, startingFrom redCubePosition: SCNVector3) {
        let sortedObjects = objectNodes.sorted { $0.key < $1.key }
        var previousPosition = redCubePosition
        
        for (index, object) in sortedObjects.enumerated() {
            print("Start node: \(object.key)")

            if index == 0 {
                // First leg: from red cube to first object
                presentRoute(in: arView, from: previousPosition, to: object.value.position)
            } else {
                // Subsequent legs: from previous object to current object
                let previousObject = sortedObjects[index - 1]
                print("End node: \(previousObject.key)")

                presentRoute(in: arView, from: previousObject.value.position, to: object.value.position)
            }
            previousPosition = object.value.position
        }
    }
    
    private func createDirectionArrows(in arView: ARSCNView, from start: SCNVector3, to end: SCNVector3) {
        let vector = SCNVector3(
            end.x - start.x,
            end.y - start.y,
            end.z - start.z
        )
        
        let distance = vector.length()
        let direction = vector.normalized()
        let arrowCount = Int(distance / arrowSpacing)

        for i in 1..<arrowCount {
            let offset = arrowSpacing * 1.05 // Adjust this multiplier to increase/decrease spacing
            let position = SCNVector3(
                start.x + direction.x * Float(i) * offset,
                start.y + direction.y * Float(i) * offset,
                start.z + direction.z * Float(i) * offset
            )
            
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
        // Create new route
        createDirectionArrows(in: arView, from: start, to: end)
        let vector = SCNVector3(
            end.x - start.x,
            end.y - start.y,
            end.z - start.z
        )
        let distance = sqrt(pow(vector.x, 2) + pow(vector.y, 2) + pow(vector.z, 2))

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
           
           // Get the camera's transform
           let cameraTransform = camera.transform
           
           // Extract the position directly from the camera transform
           let cubePosition = SCNVector3(
               cameraTransform.columns.3.x,
               fixedHeight, // We keep the fixed height as before
               cameraTransform.columns.3.z
           )
           
           cubeNode.position = cubePosition
           
           arView.scene.rootNode.addChildNode(cubeNode)
           redCubeNode = cubeNode
           
           print("Red cube placed at camera position: \(cubePosition)")
           return cubePosition
       }
    
    private func addObjectCubes(in arView: ARSCNView, qrTransform: simd_float4x4, redCubePosition: SCNVector3) {
            for object in arObjects {
                let cubeNode = createCube(color: object.color)
                
                // Calculate the world position based on QR code transform
                var worldPosition = simd_float4(object.position.x, 0, object.position.z, 1)
                worldPosition = simd_mul(qrTransform, worldPosition)
                
                // Set the cube's position, forcing Y to be at fixedHeight
                cubeNode.position = SCNVector3(
                    worldPosition.x,
                    fixedHeight,
                    worldPosition.z
                )
                
                cubeNode.name = object.name
                arView.scene.rootNode.addChildNode(cubeNode)
                objectNodes[object.name] = cubeNode
                
                print("Placed \(object.name) at position: \(cubeNode.position)")
            }
        }

//        private func presentRoute(in arView: ARSCNView, from start: SCNVector3, to end: SCNVector3) {
//            // Create new route
//            createDirectionArrows(in: arView, from: start, to: end)
//            let vector = SCNVector3(
//                end.x - start.x,
//                0, // Ignore Y difference
//                end.z - start.z
//            )
//            let distance = sqrt(pow(vector.x, 2) + pow(vector.z, 2))
//
//            print("Route:")
//            print("Start: \(SCNVector3(start.x, fixedHeight, start.z))")
//            print("End: \(SCNVector3(end.x, fixedHeight, end.z))")
//            print("Vector: \(vector)")
//            print("Distance: \(String(format: "%.2f", distance)) meters")
//        }
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

extension SCNGeometry {
    static func line(from vectorA: SCNVector3, to vectorB: SCNVector3) -> SCNGeometry {
        let vertices: [SCNVector3] = [vectorA, vectorB]
        let vertexSource = SCNGeometrySource(vertices: vertices)
        let indices: [UInt32] = [0, 1]
        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<UInt32>.size)
        let element = SCNGeometryElement(data: indexData, primitiveType: .line, primitiveCount: 1, bytesPerIndex: MemoryLayout<UInt32>.size)
        let geometry = SCNGeometry(sources: [vertexSource], elements: [element])
        return geometry
    }
}

extension SCNVector3 {
    func distance(to vector: SCNVector3) -> Float {
        let deltaX = vector.x - self.x
        let deltaY = vector.y - self.y
        let deltaZ = vector.z - self.z
        return sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)
    }

    func normalized() -> SCNVector3 {
        let length = self.length()
        return SCNVector3(self.x / length, self.y / length, self.z / length)
    }

    func length() -> Float {
        return sqrt(x * x + y * y + z * z)
    }
}
