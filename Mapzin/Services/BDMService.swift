//
//  BDMFileManger.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import ARKit

class BDMService {
    func parseBDMFile(filePath: String) -> [simd_float4x4]? {
        var transforms = [simd_float4x4]()
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            let count = data.count / MemoryLayout<simd_float4x4>.size
            transforms = data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> [simd_float4x4] in
                let bufferPointer = pointer.bindMemory(to: simd_float4x4.self)
                return Array(bufferPointer.prefix(count))
            }
        }
        
        return transforms
    }
}

