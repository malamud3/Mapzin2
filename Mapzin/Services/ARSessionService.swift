//
//  ARSessionService.swift
//  Mapzin
//
//  Created by Amir Malamud on 11/07/2024.
//


//
//  ARSessionService.swift
//  Mapzin
//
//  Created by Amir Malamud on 11/07/2024.
//

import ARKit

class ARSessionService: NSObject, ARSessionServiceProtocol, ARSCNViewDelegate, ARSessionDelegate {
    weak var delegate: ARSessionServiceDelegate?
    private(set) weak var arView: ARSCNView?
    private let cameraService: ARCameraServiceProtocol
    
    init(cameraService: ARCameraServiceProtocol = ARCameraService()) {
        self.cameraService = cameraService
        super.init()
    }

    func setupARView(_ arView: ARSCNView) {
        self.arView = arView
        arView.delegate = self
        arView.session.delegate = self
        arView.automaticallyUpdatesLighting = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .none
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            configuration.detectionImages = referenceImages
            configuration.maximumNumberOfTrackedImages = 1
        }

        arView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
        print("AR session started with horizontal and vertical plane detection")
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            delegate?.didAdd(anchor: anchor, in: session)
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let cameraPosition = cameraService.updateCameraPosition(frame: frame) {
            delegate?.didUpdateCameraPosition(cameraPosition)
        }
    }
}
