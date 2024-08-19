import ARKit
import SwiftUI
import SceneKit
import Combine



class ARViewModel: NSObject, ObservableObject {
    @Published var detectedQRCodePosition: SCNVector3?
    @Published var cameraPosition: SCNVector3?
    
    @Published var objectInstructions: [String] = []
    @Published var detectedObjects: [String] = []
    @Published var currentInstruction: Instruction? {
            didSet {
                print("Current Instruction updated: \(String(describing: currentInstruction))")
            }
        }
    @Published var isAtDestination: Bool = false

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
    private var cancellables = Set<AnyCancellable>()
    private let destinationThreshold: Float = 1.15

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
                checkDestinationReached()
            } else {
                print("arView is nil in updateRoute")
            }
        }
    
    private func checkDestinationReached() {
           guard let userPosition = cameraPosition,
                 let destination = navigationService.getObjects().last?.position else {
               return
           }
           
           let distance = calculateDistance(from: userPosition, to: destination)
           isAtDestination = distance <= destinationThreshold
           
           if isAtDestination {
       
               let instruction = Instruction(roomName: "You have reached your destination.", direction: nil, distance: nil)
               self.currentInstruction = instruction
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
                   checkDestinationReached()
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
           
           if arSessionService.arView != nil {
               updateRoute()
           }
       }



    private func updateDetectedObjects() {
        detectedObjects = navigationService.getObjects().map { $0.name }
    }


    func updateNavigationInstructions() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                      let camPosition = self.cameraPosition,
                      let targetObject = self.navigationService.getObjects().last else {
                    return
                }
                
                let targetPosition = targetObject.position
                
                let updatedInstruction = self.navigationService.instructionService.generateInstruction(
                    from: camPosition,
                    to: targetPosition,
                    roomName: targetObject.name
                )
                
                self.currentInstruction = updatedInstruction
                
                print("Updated navigation instruction: \(updatedInstruction)")
                
                self.checkDestinationReached()
            }
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
            self.updateNavigationInstructions()

        }
    }
}
