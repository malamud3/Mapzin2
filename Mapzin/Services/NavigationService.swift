//
//  NavigationService.swift
//  Mapzin
//
//  Created by Amir Malamud on 21/07/2024.
//

import ARKit
import SceneKit
import SwiftUI

class NavigationService {
    func handleAnchorDetection(anchor: ARAnchor, arView: ARSCNView?, detectedQRCodePosition: Binding<SCNVector3?>, qrCodeOrigin: Binding<SCNVector3?>, isNavigatingToDoor: Binding<Bool>) {
        if let imageAnchor = anchor as? ARImageAnchor {
            let referenceImageName = imageAnchor.referenceImage.name
            print("Detected marker with name: \(referenceImageName ?? "Unknown")")

            if referenceImageName == "Opening0" {
                let anchorPosition = SCNVector3(
                    imageAnchor.transform.columns.3.x,
                    imageAnchor.transform.columns.3.y,
                    imageAnchor.transform.columns.3.z
                )
                print("Detected Opening0 at position: \(anchorPosition)")
                detectedQRCodePosition.wrappedValue = anchorPosition
                qrCodeOrigin.wrappedValue = anchorPosition
                if let arView = arView {
                    addVisualIndicator(at: anchorPosition, to: arView)
                    addVisualIndicator(at: SCNVector3(0.568, -0.478, -1.851), to: arView, color: .green)
                }
                isNavigatingToDoor.wrappedValue = true
            }
        }
    }

    func handleCameraPositionUpdate(position: SCNVector3, qrCodeOrigin: SCNVector3?, arView: ARSCNView?, cameraPosition: Binding<SCNVector3?>, isRedBoxPlaced: Binding<Bool>) {
        if let origin = qrCodeOrigin {
            let relativePosition = SCNVector3(
                position.x - origin.x,
                position.y - origin.y,
                position.z - origin.z
            )
            print("Updated relative camera position: \(relativePosition)")
            cameraPosition.wrappedValue = relativePosition

            if !isRedBoxPlaced.wrappedValue, let arView = arView {
                addRedBox(at: SCNVector3(0, 0, 0), to: arView)
                isRedBoxPlaced.wrappedValue = true
            }
        } else {
            print("QR code not scanned yet. Camera position not updated.")
        }
    }

    func generateNavigationInstructions(cameraPosition: SCNVector3?, isNavigatingToDoor: Bool, qrCodeOrigin: SCNVector3?, door0Position: SCNVector3) -> String {
        guard let camPosition = cameraPosition, isNavigatingToDoor else {
            return "Scan the Opening0 QR code to start navigation."
        }

        let doorRelativePosition = SCNVector3(
            door0Position.x - qrCodeOrigin!.x,
            door0Position.y - qrCodeOrigin!.y,
            door0Position.z - qrCodeOrigin!.z
        )

        let deltaX = doorRelativePosition.x - camPosition.x
        let deltaY = doorRelativePosition.y - camPosition.y
        let deltaZ = doorRelativePosition.z - camPosition.z

        let distance = sqrt(pow(deltaX, 2) + pow(deltaY, 2) + pow(deltaZ, 2))

        if distance < 0.5 {
            return "You have reached Door0."
        } else {
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

    private func addVisualIndicator(at position: SCNVector3, to arView: ARSCNView, color: UIColor = .red) {
        let indicator = SCNNode(geometry: SCNSphere(radius: 0.05))
        indicator.position = position
        indicator.geometry?.firstMaterial?.diffuse.contents = color
        arView.scene.rootNode.addChildNode(indicator)
    }

    private func addRedBox(at position: SCNVector3, to arView: ARSCNView) {
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        boxGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.position = position
        arView.scene.rootNode.addChildNode(boxNode)
    }
}
