//
//  FloorDetector.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import simd

class FloorDetector {
    func identifyFloorPosition(from transforms: [simd_float4x4]) -> simd_float4x4? {
        // Find the transformation with the lowest y-coordinate
        let floorTransform = transforms.min(by: { $0.columns.3.y < $1.columns.3.y })
        return floorTransform
    }
}

