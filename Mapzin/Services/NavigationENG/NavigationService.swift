//
//  NavigationService.swift
//  Mapzin
//
//  Created by Amir Malamud on 21/07/2024.
//

import SceneKit
import ARKit

class NavigationService {
    let door0Position: SCNVector3
    let window0Position: SCNVector3
    
    init(door0Position: SCNVector3, window0Position: SCNVector3) {
        self.door0Position = door0Position
        self.window0Position = window0Position
    }

    func updateDoorNavigation(from camPosition: SCNVector3, qrOrigin: SCNVector3) -> String {
        let doorRelativePosition = calculateRelativePosition(of: door0Position, from: qrOrigin)
        let distanceToDoor = calculateDistance(from: camPosition, to: doorRelativePosition)
        
        if distanceToDoor < 0.5 {
            return "You have reached Door0."
        } else {
            return generateDirections(from: camPosition, to: doorRelativePosition, distance: distanceToDoor)
        }
    }
    
    func updateWindowDetection(from qrOrigin: SCNVector3, arView: ARSCNView) -> [SCNVector3] {
        var detectedWindows: [SCNVector3] = []
        
        let windowPositions = [window0Position] // Add more window positions here
        
        for windowPosition in windowPositions {
            let relativePosition = calculateRelativePosition(of: windowPosition, from: qrOrigin)
            detectedWindows.append(relativePosition)
            
            VisualIndicatorService.addVisualIndicator(at: relativePosition, to: arView, color: .blue)
        }
        
        return detectedWindows
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
}
