//
//  QRCodeServiceProtocol.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/07/2024.
//

import ARKit
import SceneKit

protocol QRCodeServiceProtocol {
    var qrCodeOrigin: SCNVector3? { get }
    func handleDetectedQRCode(anchor: ARImageAnchor, arView: ARSCNView) -> SCNVector3?
}
