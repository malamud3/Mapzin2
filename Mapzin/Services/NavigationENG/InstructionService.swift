//
//  InstructionService.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/08/2024.
//

import Foundation
import SceneKit

struct Instruction: Equatable {
    let roomName: String
    let direction: String?
    let distance: Float?
}

class InstructionService {
    
    func generateInstruction(from start: SCNVector3, to end: SCNVector3, roomName: String) -> Instruction {
        let vector = end - start
        let distance = vector.length()
        let direction = getDirection(from: start, to: end)
        
        return Instruction(roomName: roomName, direction: direction, distance: distance)
    }
    
    private func getDirection(from start: SCNVector3, to end: SCNVector3) -> String {
        let dx = end.x - start.x
        let dz = end.z - start.z
        
        if abs(dx) > abs(dz) {
            return dx > 0 ?  "to your left" : "to your right"
        } else {
            return dz > 0 ?  "behind you"  : "in front of you" 
        }
    }
}
