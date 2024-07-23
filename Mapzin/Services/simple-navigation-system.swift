import SceneKit

class SimpleNavigationSystem {
    var nodes: [SCNNode] = []
    var currentPosition: SCNVector3
    let destinationName = "Door0"
    let destinationPosition = SCNVector3(0.568, -0.473, -1.851)
    
    init(startPosition: SCNVector3) {
        self.currentPosition = startPosition
    }
    
    func parseSCNFile(named filename: String) {
        guard let scene = SCNScene(named: filename) else {
            print("Failed to load scene file: \(filename)")
            return
        }
        
        scene.rootNode.enumerateChildNodes { (node, _) in
            self.nodes.append(node)
        }
        
        print("Parsed \(nodes.count) nodes from the SCN file.")
        for node in nodes {
            print("Node name: \(node.name ?? "Unnamed node")")
        }
    }
    
    func updatePosition(_ newPosition: SCNVector3) {
        currentPosition = newPosition
    }
    
    func calculateNavigationInfo() -> String {
        var info = ""
        
        // 1. Current position
        info += "1. Current position: \(vectorToString(currentPosition))\n"
        
        // 2. Door0 based on current position (relative position)
        let relativePosition = SCNVector3(
            destinationPosition.x - currentPosition.x,
            destinationPosition.y - currentPosition.y,
            destinationPosition.z - currentPosition.z
        )
        info += "2. \(destinationName) based on current position: \(vectorToString(relativePosition))\n"
        
        // 3. Distance to Door0
        let distance = calculateDistance(from: currentPosition, to: destinationPosition)
        info += "3. Distance to \(destinationName): \(String(format: "%.3f", distance)) meters"
        
        return info
    }
    
    private func calculateDistance(from: SCNVector3, to: SCNVector3) -> Float {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let dz = to.z - from.z
        return sqrt(dx*dx + dy*dy + dz*dz)
    }
    
    private func vectorToString(_ vector: SCNVector3) -> String {
        return String(format: "(%.3f, %.3f, %.3f)", vector.x, vector.y, vector.z)
    }
    
    func findNodeByName(_ name: String) -> SCNNode? {
        return nodes.first { $0.name == name }
    }
    
    func distanceBetweenNodes(name1: String, name2: String) -> Float? {
        guard let node1 = findNodeByName(name1),
              let node2 = findNodeByName(name2) else {
            return nil
        }
        return calculateDistance(from: node1.position, to: node2.position)
    }
    
    func nearestNodeTo(position: SCNVector3) -> SCNNode? {
        return nodes.min(by: { calculateDistance(from: position, to: $0.position) < calculateDistance(from: position, to: $1.position) })
    }
}
