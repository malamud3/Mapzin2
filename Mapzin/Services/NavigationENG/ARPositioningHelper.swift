//
//  ARPositioningHelper.swift
//  Mapzin
//
//  Created by Amir Malamud on 18/08/2024.
//

import ARKit

struct ARPositioningHelper {
    static func calculateRelativeTransform(
        anchorTransform: simd_float4x4,
        targetLocalPosition: SIMD3<Float>,
        targetLocalRotation: simd_quatf
    ) -> simd_float4x4 {
        // Extract position from anchor transform
        let anchorPosition = simd_float3(anchorTransform.columns.3.x, anchorTransform.columns.3.y, anchorTransform.columns.3.z)
        
        // Extract rotation from anchor transform
        let anchorRotation = simd_quatf(anchorTransform)
        
        // Create transform matrices
        let anchorTransformMatrix = simd_float4x4(
            rotation: anchorRotation,
            translation: anchorPosition
        )
        let targetLocalTransform = simd_float4x4(
            rotation: targetLocalRotation,
            translation: targetLocalPosition
        )
        
        // Calculate the relative transform
        return anchorTransformMatrix * targetLocalTransform
    }
    
    static func placeObject(
        relativeTo anchor: ARImageAnchor,
        at localPosition: SIMD3<Float>,
        withRotation localRotation: simd_quatf
    ) -> SCNNode {
        let node = SCNNode()
        
        let relativeTransform = calculateRelativeTransform(
            anchorTransform: anchor.transform,
            targetLocalPosition: localPosition,
            targetLocalRotation: localRotation
        )
        
        node.simdTransform = relativeTransform
        return node
    }
}

extension simd_float4x4 {
    init(rotation: simd_quatf, translation: SIMD3<Float>) {
        let rotationMatrix = simd_float3x3(rotation)
        self.init(
            SIMD4<Float>(rotationMatrix.columns.0, 0),
            SIMD4<Float>(rotationMatrix.columns.1, 0),
            SIMD4<Float>(rotationMatrix.columns.2, 0),
            SIMD4<Float>(translation.x, translation.y, translation.z, 1)
        )
    }
}
