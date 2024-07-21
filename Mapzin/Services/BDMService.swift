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
            nodes.append(node)
        }

        print("Parsed \(nodes.count) nodes from the SCN file.")
        return nodes
    }

    func getTransformsWithNames(from nodes: [SCNNode]) -> [(simd_float4x4, String, SCNVector3, SCNVector3, SCNVector3)] {
        return nodes.map { node in
            let transform = node.simdTransform
            let name = node.name ?? "Unnamed"
            let position = node.position
            let scale = node.scale
            let rotation = node.eulerAngles
            return (transform, name, position, scale, rotation)
        }
    }
}
