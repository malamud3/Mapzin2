//
//  NavigationServiceProtocol.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/07/2024.
//

import SceneKit
import ARKit

protocol NavigationServiceProtocol {
    func updateDoorNavigation(from camPosition: SCNVector3, qrOrigin: SCNVector3) -> String
    func updateWindowDetection(from qrOrigin: SCNVector3, arView: ARSCNView) -> [SCNVector3]
}
