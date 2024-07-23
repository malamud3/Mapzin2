import ARKit
import SwiftUI
import SceneKit

class ARViewModel: NSObject, ObservableObject, ARViewModelProtocol {
    @Published private(set) var measurements: [(total: Float, x: Float, y: Float, z: Float)] = []
    @Published var navigationInstructions: String = "Looking for QR code..."
    @Published var doorNavigationInstructions: String = ""
    @Published var detectedWindows: [SCNVector3] = []
    
    private let qrHandleService: QRHandleService
    private let navigationService: NavigationService
    private let visualIndicatorService: VisualIndicatorService
    private let bdmService: BDMService
    private let arCameraService: ARCameraService
    
    let door0Position: SCNVector3
    let window0Position: SCNVector3

    var isNavigatingToDoor = false
    var isRedBoxPlaced = false

    var arSessionService: ARSessionServiceProtocol

    init(
        arSessionService: ARSessionServiceProtocol = ARSessionService(),
        bdmService: BDMService = BDMService(),
        qrHandleService: QRHandleService,
        navigationService: NavigationService,
        visualIndicatorService: VisualIndicatorService,
        arCameraService: ARCameraService = ARCameraService()
    ) {
        self.arSessionService = arSessionService
        self.bdmService = bdmService
        self.qrHandleService = qrHandleService
        self.navigationService = navigationService
        self.visualIndicatorService = visualIndicatorService
        self.arCameraService = arCameraService
        self.door0Position = MockData.position1.toSCNVector3()
        self.window0Position = MockData.position2.toSCNVector3()
        super.init()
        self.arSessionService.delegate = self
        self.arCameraService.delegate = self
    }

    func setupARView(_ arView: ARSCNView) {
        arSessionService.setupARView(arView)
        loadAndPrintSceneNodes(from: "Salon.scn")
    }

    func didAdd(anchor: ARAnchor, in session: ARSession) {
        if let imageAnchor = anchor as? ARImageAnchor, let arView = arSessionService.arView {
            if let qrOrigin = qrHandleService.handleDetectedQRCode(anchor: imageAnchor, arView: arView) {
                arCameraService.setQRCodeOrigin(qrOrigin)
                isNavigatingToDoor = true
                visualIndicatorService.addVisualIndicator(at: door0Position, to: arView, color: .green)
                visualIndicatorService.addVisualIndicator(at: window0Position, to: arView, color: .magenta)
                updateNavigationInstructions()
            }
        }
    }
    
    private func loadAndPrintSceneNodes(from filename: String) {
        if let nodes = bdmService.parseSCNFile(named: filename) {
            bdmService.printNodeDetails(nodes)
        } else {
            print("No nodes parsed from the file.")
        }
    }

    private func updateNavigationInstructions() {
        guard let camPosition = arCameraService.cameraPosition, let qrOrigin = arCameraService.qrCodeOrigin, isNavigatingToDoor else {
            navigationInstructions = "Scan the Opening0 QR code to start navigation."
            return
        }

        doorNavigationInstructions = navigationService.updateDoorNavigation(from: camPosition, qrOrigin: qrOrigin)
        detectedWindows = navigationService.updateWindowDetection(from: qrOrigin, arView: arSessionService.arView!)
        
        navigationInstructions = "Door: \(doorNavigationInstructions)\nDetected Windows: \(detectedWindows.count)"
    }
}

extension ARViewModel: ARCameraServiceDelegate {
    func didUpdateCameraPosition(_ position: SCNVector3) {
        updateNavigationInstructions()
        
        if !isRedBoxPlaced, arCameraService.qrCodeOrigin != nil, let arView = arSessionService.arView {
            visualIndicatorService.addRedBox(at: SCNVector3(0, 0, 0), to: arView)
            isRedBoxPlaced = true
        }
    }
}

