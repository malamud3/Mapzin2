import ARKit
import SwiftUI
import SceneKit

class ARViewModel: NSObject, ObservableObject, ARViewModelProtocol {
    @Published private(set) var measurements: [(total: Float, x: Float, y: Float, z: Float)] = []
    @Published var navigationInstructions: String = "Looking for QR code..."
    @Published var detectedQRCodePosition: SCNVector3?
    @Published var cameraPosition: SCNVector3?
    
    @Published var doorNavigationInstructions: String = ""
    @Published var detectedWindows: [SCNVector3] = []
    
     var qrCodeOrigin: SCNVector3?
     let door0Position = SCNVector3(-0.568, -0.478,  -1.851)
     let window0Position = SCNVector3(-8, -0.478,  0.622) // Corrected spelling

     var isNavigatingToDoor = false
     var isRedBoxPlaced = false
     private let bdmService: BDMService

    var arSessionService: ARSessionServiceProtocol
    private let cameraService: ARCameraServiceProtocol

    init(
            arSessionService: ARSessionServiceProtocol = ARSessionService(), cameraService: ARCameraServiceProtocol = ARCameraService(),
            bdmService: BDMService = BDMService()) {
        self.arSessionService = arSessionService
        self.cameraService = cameraService
        self.bdmService = bdmService
        super.init()
        self.arSessionService.delegate = self
    }

    func setupARView(_ arView: ARSCNView) {
        arSessionService.setupARView(arView)
        loadAndPrintSceneNodes(from: "Salon.scn")
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
                updateQRCodePosition(anchorPosition)
                if let arView = arSessionService.arView {
                    addVisualIndicator(at: anchorPosition, to: arView)
                    addVisualIndicator(at: door0Position, to: arView, color: .green)
                    addVisualIndicator(at: window0Position, to: arView, color: .magenta)
                }
                isNavigatingToDoor = true
            }
        }
    }
    // New method to load and print scene nodes using BDMService
    private func loadAndPrintSceneNodes(from filename: String) {
        if let nodes = bdmService.parseSCNFile(named: filename) {
            bdmService.printNodeDetails(nodes)
        } else {
            print("No nodes parsed from the file.")
        }
    }
    func didUpdateCameraPosition(_ position: SCNVector3) {
        updateCameraPosition(position)
    }

    private func updateQRCodePosition(_ position: SCNVector3) {
        let clampedRelativePosition = SCNVector3(
                    clamp(value: position.x, lower: -0.5, upper: 0.5),
                    clamp(value: position.y, lower: -0.5, upper: 0.5),
                    clamp(value: position.z, lower: -0.5, upper: 0.5)
                )
        detectedQRCodePosition = clampedRelativePosition
        qrCodeOrigin = clampedRelativePosition
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
        guard let camPosition = cameraPosition, let qrOrigin = qrCodeOrigin, isNavigatingToDoor else {
            navigationInstructions = "Scan the Opening0 QR code to start navigation."
            return
        }

        updateDoorNavigation(from: camPosition, qrOrigin: qrOrigin)
        updateWindowDetection(from: qrOrigin)
        
        navigationInstructions = "Door: \(doorNavigationInstructions)\nDetected Windows: \(detectedWindows.count)"
    }
    
    private func updateDoorNavigation(from camPosition: SCNVector3, qrOrigin: SCNVector3) {
        let doorRelativePosition = calculateRelativePosition(of: door0Position, from: qrOrigin)
        let distanceToDoor = calculateDistance(from: camPosition, to: doorRelativePosition)
        
        if distanceToDoor < 0.5 {
            doorNavigationInstructions = "You have reached Door0."
        } else {
            doorNavigationInstructions = generateDirections(from: camPosition, to: doorRelativePosition, distance: distanceToDoor)
        }
        
        print("Updated door navigation instructions: \(doorNavigationInstructions)")
    }
    
    private func updateWindowDetection(from qrOrigin: SCNVector3) {
        detectedWindows.removeAll()
        
        let windowPositions = [window0Position] // Add more window positions here
        
        for windowPosition in windowPositions {
            let relativePosition = calculateRelativePosition(of: windowPosition, from: qrOrigin)
            detectedWindows.append(relativePosition)
            
            if let arView = arSessionService.arView {
                addVisualIndicator(at: relativePosition, to: arView, color: .blue)
            }
        }
        
        print("Detected windows: \(detectedWindows.count)")
    }

    // Calculates the relative position of the door based on the QR code origin
    private func calculateRelativePosition(of targetPosition: SCNVector3, from originPosition: SCNVector3) -> SCNVector3 {
        return SCNVector3(
            targetPosition.x - originPosition.x,
            targetPosition.y - originPosition.y,
            targetPosition.z - originPosition.z
        )
    }

    // Calculates the Euclidean distance between two positions
    private func calculateDistance(from startPosition: SCNVector3, to endPosition: SCNVector3) -> Float {
        let deltaX = endPosition.x - startPosition.x
        let deltaY = endPosition.y - startPosition.y
        let deltaZ = endPosition.z - startPosition.z
        
        return sqrt(pow(deltaX, 2) + pow(deltaY, 2) + pow(deltaZ, 2))
    }

    // Generates navigation instructions based on the relative position and distance to the target
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
    private func clamp(value: Float, lower: Float, upper: Float) -> Float {
        return min(max(value, lower), upper)
    }

}
