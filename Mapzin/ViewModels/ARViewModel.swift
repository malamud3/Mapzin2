import ARKit
import SwiftUI
import SceneKit

class ARViewModel: NSObject, ObservableObject, ARViewModelProtocol {
    @Published private(set) var measurements: [(total: Float, x: Float, y: Float, z: Float)] = []
    @Published var navigationInstructions: String = "Looking for QR code..."
    @Published var detectedQRCodePosition: SCNVector3?
    @Published var cameraPosition: SCNVector3?
    
    private var qrCodeOrigin: SCNVector3?
    private let door0Position = SCNVector3(0.568, -0.478, -1.851)
    private var isNavigatingToDoor = false
    private var isRedBoxPlaced = false
    
    var arSessionService: ARSessionServiceProtocol
    private let cameraService: ARCameraServiceProtocol

    init(arSessionService: ARSessionServiceProtocol = ARSessionService(), cameraService: ARCameraServiceProtocol = ARCameraService()) {
        self.arSessionService = arSessionService
        self.cameraService = cameraService
        super.init()
        self.arSessionService.delegate = self
    }

    func setupARView(_ arView: ARSCNView) {
        arSessionService.setupARView(arView)
    }

    func didAdd(anchor: ARAnchor, in session: ARSession) {
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
                updateQRCodePosition(anchorPosition)
                if let arView = arSessionService.arView {
                    addVisualIndicator(at: anchorPosition, to: arView)
                    addVisualIndicator(at: door0Position, to: arView, color: .green)
                }
                isNavigatingToDoor = true
            }
        }
    }

    func didUpdateCameraPosition(_ position: SCNVector3) {
        updateCameraPosition(position)
    }

    private func updateQRCodePosition(_ position: SCNVector3) {
        print("Updated QR code position (Opening0): \(position)")
        detectedQRCodePosition = position
        qrCodeOrigin = position
        updateNavigationInstructions()
    }

    private func updateCameraPosition(_ position: SCNVector3) {
        if let origin = qrCodeOrigin {
            let relativePosition = SCNVector3(
                position.x - origin.x,
                position.y - origin.y,
                position.z - origin.z
            )
            print("Updated relative camera position: \(relativePosition)")
            cameraPosition = relativePosition

            if !isRedBoxPlaced, let arView = arSessionService.arView {
                addRedBox(at: SCNVector3(0, 0, 0), to: arView)
                isRedBoxPlaced = true
            }
        } else {
            print("QR code not scanned yet. Camera position not updated.")
        }
        updateNavigationInstructions()
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

    private func updateNavigationInstructions() {
        guard let camPosition = cameraPosition, isNavigatingToDoor else {
            navigationInstructions = "Scan the Opening0 QR code to start navigation."
            return
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
            navigationInstructions = "You have reached Door0."
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
            navigationInstructions = instructions
        }
        
        print("Door0 relative position: \(doorRelativePosition)")
        print("Updated navigation instructions: \(navigationInstructions)")
    }
}

extension ARViewModel: ARSessionDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Handle session failures
        print("AR Session failed: \(error.localizedDescription)")
        
        if let arError = error as? ARError {
            switch arError.code {
            case .cameraUnauthorized:
                // Handle camera permissions error
                print("Camera access is not authorized. Please enable camera access in Settings.")
            case .sensorUnavailable:
                // Handle sensor unavailability
                print("Required sensor is unavailable. This device might not support all AR features.")
            case .worldTrackingFailed:
                // Handle tracking failures
                print("World tracking failed. Try moving to a different area with more distinct features.")
            default:
                // Handle other AR errors
                print("An unexpected AR error occurred: \(arError.localizedDescription)")
            }
        }
        
        // Optionally, you can try to recover from the error by restarting the session
        restartSession()
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Handle session interruptions
        print("AR Session was interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Handle ended session interruptions
        print("AR Session interruption ended")
        restartSession()
    }
    
    private func restartSession() {
        guard let arView = arSessionService.arView else { return }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = .sceneDepth
        configuration.planeDetection = [.horizontal, .vertical]
        
        arView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
}
