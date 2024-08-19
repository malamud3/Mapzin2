import ARKit
import SwiftUI
import SceneKit
import Combine



class ARViewModel: NSObject, ObservableObject {
    @Published var navigationInstructions: String = "Looking for QR code..."
    @Published var detectedQRCodePosition: SCNVector3?
    @Published var cameraPosition: SCNVector3?
    
    @Published var objectInstructions: [String] = []
    @Published var detectedObjects: [String] = []
    @Published var doorNavigationInstructions: String = ""
    @Published var detectedWindows: [SCNVector3] = []
    @Published var currentRoom: String = ""
    @Published var currentInstruction: Instruction? {
            didSet {
                print("Current Instruction updated: \(String(describing: currentInstruction))")
            }
        }
    private var cancellables = Set<AnyCancellable>()

    @Published var selectedItemObject: ARObject? {
            didSet {
                if let newObject = selectedItemObject {
                    addObject(newObject)
                    updateObjectInstructions()
                    updateRoute()
                }
            }
        }
    
    var arSessionService: ARSessionServiceProtocol
    private let navigationService: NavigationService
    private let bdmService: BDMService
    private let cameraService: ARCameraServiceProtocol
    private var sceneNodes: [NodeData] = []

    init(
            arSessionService: ARSessionServiceProtocol = ARSessionService(),
            bdmService: BDMService = BDMService(),
            cameraService: ARCameraServiceProtocol = ARCameraService()
        ) {
            self.arSessionService = arSessionService
            self.navigationService = NavigationService()
            self.bdmService = bdmService
            self.cameraService = cameraService
            super.init()
            self.arSessionService.delegate = self
            loadSceneData()
            setupBindings()
        }
    private func setupBindings() {
            navigationService.$currentInstruction
                .receive(on: DispatchQueue.main)
                .sink { [weak self] instruction in
                    self?.currentInstruction = instruction
                    print("ARViewModel received instruction update: \(String(describing: instruction))")
                }
                .store(in: &cancellables)
        }

    func updateRoute() {
           print("updateRoute called")
           if let arView = arSessionService.arView {
               navigationService.updateRoute(in: arView)
           } else {
               print("arView is nil in updateRoute")
           }
       }
    
    private func updateCurrentInstruction() {
        
           guard let start = cameraPosition,
                 let end = selectedItemObject?.position else {
               currentInstruction = nil
               return
           }
                print("updateCurrentInstruction called")
                print("Camera Position: \(String(describing: cameraPosition))")
                print("Selected Item Object: \(String(describing: selectedItemObject))")
           let vector = end - start
           let distance = vector.length()
           let direction = getDirection(from: start, to: end)
           let roomName = currentRoom.isEmpty ? "Unknown Room" : currentRoom
           
           DispatchQueue.main.async {
               self.currentInstruction = Instruction(roomName: roomName, direction: direction, distance: distance)
           }
       }
    func setupARView(_ arView: ARSCNView) {
        arSessionService.setupARView(arView)
//        loadSceneData()
    }

    private func loadSceneData() {
        if let nodes = bdmService.parseSCNFile(named: "Amir.scn") {
//            self.sceneNodes = nodes
//            self.availableRooms = nodes.filter { $0.name.hasSuffix("Room0") }.map { $0.name }
        }
    }

    func addObject(_ object: ARObject) {
        if (detectedQRCodePosition != nil) {
               navigationService.addObject(object)
               updateObjectInstructions()
               updateDetectedObjects()
               
               if let arView = arSessionService.arView {
                   navigationService.updateRoute(in: arView)
                   print("Route updated with new object: \(object.name)")
               } else {
                   print("ARView is nil, cannot update route")
               }
           } else {
               print("QR code not detected yet. Object \(object.name) added to pending list.")
           }
       }


    
    private func updateObjectInstructions() {
            objectInstructions.removeAll()
            for object in navigationService.getObjects() {
                objectInstructions.append("\(object.name) cube placed at its position relative to the QR code.")
            }
        }


    func removeObject(named name: String) {
        navigationService.removeObject(named: name)
        updateObjectInstructions()
        updateDetectedObjects()
        
        // If we have an ARView, update the route
        if (arSessionService.arView) != nil {
            updateRoute()
        }
    }



    private func updateDetectedObjects() {
        detectedObjects = navigationService.getObjects().map { $0.name }
    }


    func updateNavigationInstructions() {
        DispatchQueue.main.async {
            guard let camPosition = self.cameraPosition else {
                self.navigationInstructions = "Scan the Opening0 QR code to start navigation."
                return
            }

            self.updateCurrentRoom(for: camPosition)
            
            let nearestDoor = self.findNearestNode(of: .door, to: camPosition)
            
            var instructions = "You are in the \(self.currentRoom). "
            
            if let door = nearestDoor {
                let distance = self.calculateDistance(from: camPosition, to: door.position)
                instructions += "Nearest door is \(String(format: "%.2f", distance)) meters \(self.getDirection(from: camPosition, to: door.position)). "
            }
                
            self.navigationInstructions = instructions
        }
    }

    private func updateCurrentRoom(for position: SCNVector3) {
        let roomNodes = sceneNodes.filter { $0.name.hasSuffix("Room0") }
        if let nearestRoom = roomNodes.min(by: { self.calculateDistance(from: position, to: $0.position) < self.calculateDistance(from: position, to: $1.position) }) {
            currentRoom = nearestRoom.name
        }
    }

    private func findNearestNode(of type: NodeType, to position: SCNVector3) -> NodeData? {
        return sceneNodes
            .filter { $0.type == type }
            .min(by: { self.calculateDistance(from: position, to: $0.position) < self.calculateDistance(from: position, to: $1.position) })
    }

    private func calculateDistance(from start: SCNVector3, to end: SCNVector3) -> Float {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let dz = end.z - start.z
        return sqrt(dx*dx + dy*dy + dz*dz)
    }

    private func getDirection(from start: SCNVector3, to end: SCNVector3) -> String {
        let dx = end.x - start.x
        let dz = end.z - start.z
        
        if abs(dx) > abs(dz) {
            return dx > 0 ? "to your right" : "to your left"
        } else {
            return dz > 0 ? "in front of you" : "behind you"
        }
    }
}

extension ARViewModel: ARSessionServiceDelegate {
    func didAdd(anchor: ARAnchor, in session: ARSession) {
            if let imageAnchor = anchor as? ARImageAnchor {
                if let newPosition = navigationService.handleAnchorDetection(anchor: imageAnchor, arView: arSessionService.arView) {
                    DispatchQueue.main.async {
                        self.detectedQRCodePosition = newPosition
                    }
                }
            }
        }

    func didUpdateCameraPosition(_ position: SCNVector3) {
        DispatchQueue.main.async {
            self.cameraPosition = position
        }
        updateNavigationInstructions()
    }
}
