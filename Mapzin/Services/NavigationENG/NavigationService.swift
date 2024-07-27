//
//  NavigationService.swift
//  Mapzin
//
//  Created by Amir Malamud on 21/07/2024.
//

import ARKit
import SwiftUI

class NavigationService {
    let door0Position = SCNVector3(-0.568, -0.478, -1.851)
    let window0Position = SCNVector3(-8, -0.478, 0.622)

    func handleAnchorDetection(anchor: ARImageAnchor, arView: ARSCNView?) -> SCNVector3? {
        let referenceImageName = anchor.referenceImage.name
        print("Detected marker with name: \(referenceImageName ?? "Unknown")")
        
        if referenceImageName == "Opening0" {
            let anchorPosition = SCNVector3(
                anchor.transform.columns.3.x,
                anchor.transform.columns.3.y,
                anchor.transform.columns.3.z
            )
            return anchorPosition
        }
        return nil
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

    func generateDoorNavigation(from camPosition: SCNVector3, qrOrigin: SCNVector3) -> String {
        let doorRelativePosition = calculateRelativePosition(of: door0Position, from: qrOrigin)
        let distanceToDoor = calculateDistance(from: camPosition, to: doorRelativePosition)
        
        if distanceToDoor < 0.5 {
            return "You have reached Door0."
        } else {
            return generateDirections(from: camPosition, to: doorRelativePosition, distance: distanceToDoor)
        }
    }

    func detectWindows(from qrOrigin: SCNVector3) -> [SCNVector3] {
        let windowPositions = [window0Position] // Add more window positions here
        return windowPositions.map { calculateRelativePosition(of: $0, from: qrOrigin) }
    }

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
                instructions += deltaZ > 0 ? "Move backward. " : "Move forward. "
            }

            instructions += String(format: "Distance: %.2f meters", distance)
            return instructions
        }

    func calculateRelativePosition(of targetPosition: SCNVector3, from originPosition: SCNVector3) -> SCNVector3 {
            return SCNVector3(
                targetPosition.x - originPosition.x,
                targetPosition.y - originPosition.y,
                targetPosition.z - originPosition.z
            )
        }

    func calculateDistance(from startPosition: SCNVector3, to endPosition: SCNVector3) -> Float {
            let deltaX = endPosition.x - startPosition.x
            let deltaY = endPosition.y - startPosition.y
            let deltaZ = endPosition.z - startPosition.z
            
            return sqrt(pow(deltaX, 2) + pow(deltaY, 2) + pow(deltaZ, 2))
        }

        func clamp(value: Float, lower: Float, upper: Float) -> Float {
            return min(max(value, lower), upper)
        }
}
