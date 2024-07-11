//
//  ARSessionService.swift
//  Mapzin
//
//  Created by Amir Malamud on 11/07/2024.
//

import ARKit

class ARSessionService {
    weak var delegate: ARSessionDelegate?
    var arView: ARSCNView?

    func setupARView(_ arView: ARSCNView) {
        self.arView = arView
        arView.delegate = delegate as? any ARSCNViewDelegate
        arView.session.delegate = delegate
        arView.automaticallyUpdatesLighting = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        print("AR session started with horizontal plane detection")
    }
}
