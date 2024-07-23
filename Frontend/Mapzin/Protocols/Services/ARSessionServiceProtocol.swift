//
//  ARSessionServiceProtocol.swift
//  Mapzin
//
//  Created by Amir Malamud on 21/07/2024.
//

import ARKit

protocol ARSessionServiceProtocol {
    var delegate: ARSessionServiceDelegate? { get set }
    func setupARView(_ arView: ARSCNView)
    var arView: ARSCNView? { get }
}

protocol ARSessionServiceDelegate: AnyObject {
    func didAdd(anchor: ARAnchor, in session: ARSession)
    func didUpdateCameraPosition(_ position: SCNVector3)
}
