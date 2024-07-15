//
//  BDMFileManger.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SceneKit
import ARKit

class BDMService {
    func parseSCNFile(named filename: String) -> [SCNNode]? {
        guard let scene = SCNScene(named: filename) else {
            print("Failed to load scene file: \(filename)")
            return nil
        }
        
        var nodes: [SCNNode] = []
        
        scene.rootNode.enumerateChildNodes { (node, _) in
            // You might want to filter nodes based on specific criteria
            // For example, only adding nodes with a specific name or type
            nodes.append(node)
        }
        
        print("Parsed \(nodes.count) nodes from the SCN file.")
        return nodes
    }
    
    func getTransformsWithNames(from nodes: [SCNNode]) -> [(simd_float4x4, String)] {
        return nodes.map { ($0.simdTransform, $0.name ?? "Unnamed") }
    }
}
