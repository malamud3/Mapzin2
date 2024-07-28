//
//  QRHandleService.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/07/2024.
//

import ARKit
import SceneKit

class QRHandleService {
    private(set) var qrCodeOrigin: SCNVector3?
    private let arSessionService: ARSessionServiceProtocol
    
    init(arSessionService: ARSessionServiceProtocol) {
        self.arSessionService = arSessionService
    }
    
    func handleDetectedQRCode(anchor: ARImageAnchor, arView: ARSCNView) -> SCNVector3? {
        guard let referenceImageName = anchor.referenceImage.name else {
            return nil
        }
        
        print("Detected marker with name: \(referenceImageName)")
        
        if referenceImageName == "Opening0" {
            let anchorPosition = SCNVector3(
                anchor.transform.columns.3.x,
                anchor.transform.columns.3.y,
                anchor.transform.columns.3.z
            )
            updateQRCodePosition(anchorPosition)
            VisualIndicatorService.addVisualIndicator(at: anchorPosition, to: arView)
            return qrCodeOrigin
        }
        return nil
    }
    
    private func updateQRCodePosition(_ position: SCNVector3) {
        let clampedRelativePosition = SCNVector3(
            clamp(value: position.x, lower: -0.4, upper: 0.4),
            clamp(value: position.y, lower: -0.5, upper: -0.4),
            clamp(value: position.z, lower: -0.5, upper: 0.5)
        )
        qrCodeOrigin = clampedRelativePosition
    }
    
    private func clamp(value: Float, lower: Float, upper: Float) -> Float {
        return min(max(value, lower), upper)
    }
}
