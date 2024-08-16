//
//  SCNVector3.swift
//  Mapzin
//
//  Created by Amir Malamud on 21/07/2024.
//

import SceneKit

import SceneKit

extension SCNVector3: Equatable {
    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    public static func !=(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return !(lhs == rhs)
    }
    func distance(to vector: SCNVector3) -> Float {
        let deltaX = vector.x - self.x
        let deltaY = vector.y - self.y
        let deltaZ = vector.z - self.z
        return sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)
    }

    func normalized() -> SCNVector3 {
        let length = self.length()
        return SCNVector3(self.x / length, self.y / length, self.z / length)
    }

    func length() -> Float {
        return sqrt(x * x + y * y + z * z)
    }
}
