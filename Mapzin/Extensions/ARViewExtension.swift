//
////
////  ARViewModel.swift
////  Mapzin
////
////  Created by Amir Malamud on 21/07/2024.
////
//
//import ARKit
//
//extension ARViewModel: ARSessionDelegate {
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Handle session failures
//        print("AR Session failed: \(error.localizedDescription)")
//        
//        if let arError = error as? ARError {
//            switch arError.code {
//            case .cameraUnauthorized:
//                // Handle camera permissions error
//                print("Camera access is not authorized. Please enable camera access in Settings.")
//            case .sensorUnavailable:
//                // Handle sensor unavailability
//                print("Required sensor is unavailable. This device might not support all AR features.")
//            case .worldTrackingFailed:
//                // Handle tracking failures
//                print("World tracking failed. Try moving to a different area with more distinct features.")
//            default:
//                // Handle other AR errors
//                print("An unexpected AR error occurred: \(arError.localizedDescription)")
//            }
//        }
//        
//        // Optionally, you can try to recover from the error by restarting the session
//        restartSession()
//    }
//    
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Handle session interruptions
//        print("AR Session was interrupted")
//    }
//    
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Handle ended session interruptions
//        print("AR Session interruption ended")
//        restartSession()
//    }
//    
//    private func restartSession() {
//        guard let arView = arSessionService.arView else { return }
//        
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.frameSemantics = .sceneDepth
//        configuration.planeDetection = [.horizontal, .vertical]
//        
//        arView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
//    }
//}
