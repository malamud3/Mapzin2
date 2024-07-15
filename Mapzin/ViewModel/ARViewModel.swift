
import ARKit
import SwiftUI
import SceneKit

class ARViewModel: NSObject, ObservableObject, ARSessionDelegate {
    @Published var measurements: [(total: Float, x: Float, y: Float, z: Float)] = []
    @Published var navigationInstructions: String = ""
    
    private let arSessionService = ARSessionService()
    private let arObjectDetectionService = ARObjectDetectionService()
    private let arCameraService = ARCameraService()
    private let floorService = FloorService()
    private let bdmService = BDMService()
    private let navigationService = NavigationService()
    private var lastPosition: SCNVector3?

    override init() {
        super.init()
        arSessionService.delegate = self
    }
    
    func setupARView(_ arView: ARSCNView) {
            arSessionService.setupARView(arView)
            
            // Load SCN file and get nodes
            if let nodes = bdmService.parseSCNFile(named: "Salon.scn") {
                let transformsWithNames = bdmService.getTransformsWithNames(from: nodes)
                print("Parsed \(transformsWithNames.count) transformation matrices with names.")
                
                for (index, (transform, name)) in transformsWithNames.enumerated() {
                    let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                    let scale = SCNVector3(transform.columns.0.x, transform.columns.1.y, transform.columns.2.z)
                    
                  
                        print("\(index): Name: \(name), Position \(position), Scale \(scale)")
                    
                    
                    // Add visual representation for debugging
                    let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
                    let node = SCNNode(geometry: box)
                    node.simdTransform = transform
                    node.name = name
                    
                    // Apply scale
                    node.scale = scale
                    
                    arView.scene.rootNode.addChildNode(node)
                }
            } else {
                print("Failed to parse SCN file.")
            }
        }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let arView = arSessionService.arView else { return }
        let touchLocation = gestureRecognizer.location(in: arView)
        let hitTestResults = arView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if let hitResult = hitTestResults.first {
            let position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                      hitResult.worldTransform.columns.3.y,
                                      hitResult.worldTransform.columns.3.z)
            
            if let cameraPosition = arView.pointOfView?.position {
                let path = navigationService.planPath(from: cameraPosition, to: position, obstacles: [])
                navigationService.displayPath(in: arView, path: path)
                updateNavigationInstructions()
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        arCameraService.updateCameraPosition(frame: frame)
        updateNavigationInstructions()
    }
    
    private func updateNavigationInstructions() {
        guard let arView = arSessionService.arView, let cameraPosition = arView.pointOfView?.position else { return }
        navigationInstructions = navigationService.getNextInstruction(userPosition: cameraPosition)
    }
}
