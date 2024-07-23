//
//  ARViewModelProtocol.swift
//  Mapzin
//
//  Created by Amir Malamud on 21/07/2024.
//

import ARKit

protocol ARViewModelProtocol: ARSessionServiceDelegate {
    var measurements: [(total: Float, x: Float, y: Float, z: Float)] { get }
    var navigationInstructions: String { get }
    func setupARView(_ arView: ARSCNView)
    func didAdd(anchor: ARAnchor, in session: ARSession)
    func didUpdateCameraPosition(_ position: SCNVector3)
}
