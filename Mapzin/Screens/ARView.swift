import SwiftUI
import ARKit

struct ARView: View {
    let buildingName: String

    var body: some View {
        ARSceneView(buildingName: buildingName)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("AR View for \(buildingName)", displayMode: .inline)
    }
}

struct ARSceneView: UIViewRepresentable {
    let buildingName: String
    let sceneView = ARSCNView()
    
    func makeUIView(context: Context) -> ARSCNView {
        // Create a basic AR scene
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal // Enable horizontal plane detection
        sceneView.session.run(configuration)
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // No updates needed here
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(sceneView: sceneView, buildingName: buildingName)
    }
    
    class Coordinator: NSObject {
        var sceneView: ARSCNView
        var buildingName: String
        
        init(sceneView: ARSCNView, buildingName: String) {
            self.sceneView = sceneView
            self.buildingName = buildingName
            super.init()
            self.sceneView.delegate = self
            self.sceneView.scene.rootNode.addChildNode(createTextNode())
            self.sceneView.scene.rootNode.addChildNode(createHeartNode())
        }
        
        // Function to create a text node
        func createTextNode() -> SCNNode {
            let textGeometry = SCNText(string: "Rotem I Love U", extrusionDepth: 1.0)
            textGeometry.firstMaterial?.diffuse.contents = UIColor.red // Text color
            let textNode = SCNNode(geometry: textGeometry)
            textNode.position = SCNVector3(-0.2, 0, -0.5) // Adjust position
            textNode.scale = SCNVector3(0.01, 0.01, 0.01) // Scale down text size
            return textNode
        }
        
        // Function to create a heart shape node
        func createHeartNode() -> SCNNode {
            let heartShape = UIBezierPath()
            heartShape.move(to: CGPoint(x: 0, y: 0))
            heartShape.addCurve(to: CGPoint(x: 0, y: 1), controlPoint1: CGPoint(x: 2, y: -1), controlPoint2: CGPoint(x: 0, y: 1.75))
            heartShape.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 0, y: 1.75), controlPoint2: CGPoint(x: -2, y: -1))
            heartShape.close()
            
            let heartGeometry = SCNShape(path: heartShape, extrusionDepth: 0.1)
            heartGeometry.firstMaterial?.diffuse.contents = UIColor.red // Heart color
            let heartNode = SCNNode(geometry: heartGeometry)
            heartNode.position = SCNVector3(0.2, 0, -0.5) // Adjust position
            return heartNode
        }
        
        // Handle tap gesture to measure distances
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let tapLocation = gesture.location(in: sceneView)
            
            guard let hitTestResult = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent).first else {
                return
            }
            
            let position = hitTestResult.worldTransform.columns.3
            let translation = SIMD3<Float>(position.x, position.y, position.z)
            let distance = simd_length(translation)
            
            print("Distance from your location to the wall: \(distance) meters")
            
            // You can add visual indicators or UI feedback here for the measured distance if needed
        }

    }
}

extension ARSceneView.Coordinator: ARSCNViewDelegate {
    // Implement ARSCNViewDelegate methods if needed
}
struct ARViewContainer: View {
    @State private var isMeasurementDisplayed = false
    @State private var distanceToWall: Float = 0.0

    var body: some View {
        VStack {
            ARView(buildingName: "Your Building Name")
                .edgesIgnoringSafeArea(.all)
            
            if isMeasurementDisplayed {
                MeasurementView(distance: distanceToWall)
            }
            
            Button(action: {
                self.isMeasurementDisplayed.toggle()
            }) {
                Image(systemName: "ruler")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .padding()
        }
    }
}

struct MeasurementView: View {
    let distance: Float
    
    var body: some View {
        VStack {
            Text("Distance to Wall:")
            Text(String(format: "%.2f meters", distance))
                .font(.title)
                .fontWeight(.bold)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
}
