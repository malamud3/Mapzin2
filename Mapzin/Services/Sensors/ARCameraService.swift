import ARKit

protocol ARCameraServiceProtocol {
    var delegate: ARCameraServiceDelegate? { get set }
    var cameraPosition: SCNVector3? { get }
    var qrCodeOrigin: SCNVector3? { get }
    
    func setQRCodeOrigin(_ origin: SCNVector3)
    func updateCameraPosition(frame: ARFrame) -> SCNVector3?
}

protocol ARCameraServiceDelegate: AnyObject {
    func didUpdateCameraPosition(_ position: SCNVector3)
}

class ARCameraService: ARCameraServiceProtocol {
    weak var delegate: ARCameraServiceDelegate?
    
    private(set) var cameraPosition: SCNVector3?
    private(set) var qrCodeOrigin: SCNVector3?
    
    private var cameraPositionReadings: [SCNVector3] = []
    
    func setQRCodeOrigin(_ origin: SCNVector3) {
        qrCodeOrigin = origin
    }
    
    func updateCameraPosition(frame: ARFrame) -> SCNVector3? {
        let cameraTransform = frame.camera.transform
        
        let cameraPosition = SCNVector3(
            x: cameraTransform.columns.3.x,
            y: cameraTransform.columns.3.y,
            z: cameraTransform.columns.3.z
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.processNewCameraPosition(cameraPosition)
        }
        
        return cameraPosition
    }
    
    private func processNewCameraPosition(_ position: SCNVector3) {
        guard let origin = qrCodeOrigin else { return }
        
        let relativePosition = SCNVector3(
            position.x - origin.x,
            position.y - origin.y,
            position.z - origin.z
        )
        
        cameraPositionReadings.append(relativePosition)
        
        if cameraPositionReadings.count > 10 {
            cameraPositionReadings.removeFirst()
        }
        
        let averagedPosition = averagePositions(cameraPositionReadings)
        
        print("Updated relative camera position: \(averagedPosition)")
        cameraPosition = averagedPosition
        
        delegate?.didUpdateCameraPosition(averagedPosition)
    }
    
    private func averagePositions(_ positions: [SCNVector3]) -> SCNVector3 {
        guard !positions.isEmpty else {
            return SCNVector3(0, 0, 0)
        }
        let sum = positions.reduce(SCNVector3(0, 0, 0)) { (result, position) in
            return SCNVector3(
                result.x + position.x,
                result.y + position.y,
                result.z + position.z
            )
        }
        return SCNVector3(
            sum.x / Float(positions.count),
            sum.y / Float(positions.count),
            sum.z / Float(positions.count)
        )
    }
}
