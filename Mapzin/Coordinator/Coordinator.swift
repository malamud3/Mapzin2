//import SwiftUI
//
//class Coordinator: ObservableObject {
//    @Published var path = NavigationPath()
//    @Published var sheet: SheetType?
//
//    func push(_ screen: AppScreenType) {
//        path.append(screen)
//    }
//
//    func present(sheet: SheetType) {
//        self.sheet = sheet
//    }
//
//    func pop() {
//        guard !path.isEmpty else { return }
//        path.removeLast()
//    }
//
//    func goToRoot() {
//        path.removeLast(path.count)
//    }
//
//    func dismissSheet() {
//        self.sheet = nil
//    }
//
//    @ViewBuilder
//    @MainActor
//    func build(screen: AppScreenType) -> some View {
//        switch screen {
//        case .welcome:
//            WelcomeView()
//        case .signUp:
//            SignUpView(viewModel: LoginViewModel())
//        case .login:
//            LoginView(viewModel: LoginViewModel())
//        case .home:
//            HomeView().environmentObject(self)
//        case .selectBuilding:
//            SelectBuildingView()
//        case .ar:
//            MyARView(buildingName: "Afeka")
//                .edgesIgnoringSafeArea(.all)
//        }
//    }
//}

import SwiftUI
import ARKit

class Coordinator: NSObject, ObservableObject, ARSCNViewDelegate, ARSessionDelegate {
    @Published var path = NavigationPath()
    @Published var sheet: SheetType?

    private var arView: ARSCNView?
    private var measurements: [(total: Float, x: Float, y: Float, z: Float)] = []
    private var lastPosition: SCNVector3?

    func push(_ screen: AppScreenType) {
        path.append(screen)
    }

    func present(sheet: SheetType) {
        self.sheet = sheet
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func goToRoot() {
        path.removeLast(path.count)
    }

    func dismissSheet() {
        self.sheet = nil
    }

    // ARKit session management
    func setupARView(_ arView: ARSCNView) {
        self.arView = arView
        arView.delegate = self
        arView.session.delegate = self
        arView.automaticallyUpdatesLighting = true

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        print("AR session started with horizontal plane detection")

        // Add a 3D object to the scene
        addBoxNode()
    }

    // Add a 3D box node to the scene
    func addBoxNode() {
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        boxNode.position = SCNVector3(0, 0, -0.5) // Place the box 0.5 meters in front of the camera
        boxNode.name = "boxNode"

        arView?.scene.rootNode.addChildNode(boxNode)
    }

    // Handle tap gesture to detect taps on the box and print distances
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        let touchLocation = gestureRecognizer.location(in: arView)
        let hitTestResults = arView.hitTest(touchLocation, options: nil)

        if let result = hitTestResults.first(where: { $0.node.name == "boxNode" }) {
            let distances = calculateDistances(to: result.node)
            measurements.append(distances)

            if measurements.count >= 5 { // Take 5 measurements and then calculate the average
                let averageDistances = calculateAverageDistances()
                print("Average distance to the object: \(averageDistances.total) meters")
                print("Average distance along X: \(averageDistances.x) meters")
                print("Average distance along Y: \(averageDistances.y) meters")
                print("Average distance along Z: \(averageDistances.z) meters")
                measurements.removeAll() // Clear the measurements after calculating the average
            }
        }
    }

    // Calculate the distances between the camera and the node along the X, Y, and Z axes
    func calculateDistances(to node: SCNNode) -> (total: Float, x: Float, y: Float, z: Float) {
        guard let cameraTransform = arView?.session.currentFrame?.camera.transform else { return (0, 0, 0, 0) }
        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        let nodePosition = node.position
        let distanceX = nodePosition.x - cameraPosition.x
        let distanceY = nodePosition.y - cameraPosition.y
        let distanceZ = nodePosition.z - cameraPosition.z
        let totalDistance = sqrt(pow(distanceX, 2) + pow(distanceY, 2) + pow(distanceZ, 2))
        return (totalDistance, distanceX, distanceY, distanceZ)
    }

    // Calculate the average distances from the measurements
    func calculateAverageDistances() -> (total: Float, x: Float, y: Float, z: Float) {
        let count = Float(measurements.count)
        let sum = measurements.reduce((total: 0, x: 0, y: 0, z: 0)) { (result, measurement) in
            return (result.total + measurement.total,
                    result.x + measurement.x,
                    result.y + measurement.y,
                    result.z + measurement.z)
        }
        return (sum.total / count, sum.x / count, sum.y / count, sum.z / count)
    }

    // Print the current position and orientation of the camera
    func printCameraPositionAndOrientation() {
        guard let cameraTransform = arView?.session.currentFrame?.camera.transform else { return }
        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)

        // Check for movement greater than the noise threshold
        if let lastPosition = lastPosition {
            let movement = abs(cameraPosition.x - lastPosition.x) + abs(cameraPosition.y - lastPosition.y) + abs(cameraPosition.z - lastPosition.z)
            if movement < 0.01 {
                return // Consider as noise, no significant movement
            }
        }

        lastPosition = cameraPosition
        let formattedPosition = SCNVector3(round(cameraPosition.x * 1000) / 1000, round(cameraPosition.y * 1000) / 1000, round(cameraPosition.z * 1000) / 1000)
        print("Camera Position: \(formattedPosition)")

        // Calculate and print the 2D angle to the object and vertical position
        if let boxNode = arView?.scene.rootNode.childNode(withName: "boxNode", recursively: false) {
            let angle = calculate2DAngleToNode(boxNode)
            let verticalPosition = cameraPosition.y > boxNode.position.y ? "below" : "above"
            print(String(format: "2D Angle to object: %.3f degrees", angle))
            print("The object is \(verticalPosition) the camera.")
        }
    }

    // Calculate the 2D angle between the camera's forward direction and the vector to the node
    func calculate2DAngleToNode(_ node: SCNNode) -> Float {
        guard let cameraTransform = arView?.session.currentFrame?.camera.transform else { return 0.0 }
        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        let nodePosition = node.position

        // Project the positions onto the horizontal plane (ignore the y-axis)
        let cameraPosition2D = SCNVector3(cameraPosition.x, 0, cameraPosition.z)
        let nodePosition2D = SCNVector3(nodePosition.x, 0, nodePosition.z)
        let vectorToNode = SCNVector3(nodePosition2D.x - cameraPosition2D.x, 0, nodePosition2D.z - cameraPosition2D.z)

        // Normalize vectors
        let cameraForward = SCNVector3(-cameraTransform.columns.2.x, 0, -cameraTransform.columns.2.z)
        let normalizedVectorToNode = normalize(vectorToNode)
        let normalizedCameraForward = normalize(cameraForward)

        // Calculate dot product
        let dotProduct = dot(normalizedVectorToNode, normalizedCameraForward)
        let angle = acos(dotProduct) * (180.0 / .pi) // Convert to degrees
        return angle
    }

    // Normalize a vector
    func normalize(_ vector: SCNVector3) -> SCNVector3 {
        let length = sqrt(vector.x * vector.x + vector.z * vector.z) // Only considering x and z for 2D normalization
        return SCNVector3(vector.x / length, 0, vector.z / length)
    }

    // Calculate dot product of two vectors
    func dot(_ v1: SCNVector3, _ v2: SCNVector3) -> Float {
        return v1.x * v2.x + v1.z * v2.z // Only considering x and z for 2D dot product
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Call the function to print camera position and orientation
        printCameraPositionAndOrientation()
    }

    @ViewBuilder
    @MainActor
    func build(screen: AppScreenType) -> some View {
        switch screen {
        case .welcome:
            WelcomeView()
        case .signUp:
            SignUpView(viewModel: LoginViewModel())
        case .login:
            LoginView(viewModel: LoginViewModel())
        case .home:
            HomeView().environmentObject(self)
        case .selectBuilding:
            SelectBuildingView()
        case .ar:
            MyARView()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
//import SwiftUI
//import ARKit
//
//class Coordinator: NSObject, ObservableObject, ARSCNViewDelegate, ARSessionDelegate {
//    @Published var path = NavigationPath()
//    @Published var sheet: SheetType?
//
//    private var arView: ARSCNView?
//    private var measurements: [(total: Float, x: Float, y: Float, z: Float)] = []
//    var knownDistance: Float = 0.5 // Default known distance, can be set dynamically
//
//    func push(_ screen: AppScreenType) {
//        path.append(screen)
//    }
//
//    func present(sheet: SheetType) {
//        self.sheet = sheet
//    }
//
//    func pop() {
//        guard !path.isEmpty else { return }
//        path.removeLast()
//    }
//
//    func goToRoot() {
//        path.removeLast(path.count)
//    }
//
//    func dismissSheet() {
//        self.sheet = nil
//    }
//
//    // ARKit session management
//    func setupARView(_ arView: ARSCNView) {
//        self.arView = arView
//        arView.delegate = self
//        arView.session.delegate = self
//        arView.automaticallyUpdatesLighting = true
//        
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal]
//        arView.session.run(configuration)
//        print("AR session started with horizontal plane detection")
//        
//        // Add a 3D object to the scene
//        addBoxNode()
//    }
//
//    // Add a 3D box node to the scene
//    func addBoxNode() {
//        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
//        boxNode.position = SCNVector3(0, 0, -0.5) // Place the box 0.5 meters in front of the camera
//        boxNode.name = "boxNode"
//        
//        arView?.scene.rootNode.addChildNode(boxNode)
//    }
//
//    // Handle tap gesture to detect taps on the box and print distances
//    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
//        guard let arView = arView else { return }
//        let touchLocation = gestureRecognizer.location(in: arView)
//        let hitTestResults = arView.hitTest(touchLocation, options: nil)
//        
//        if let result = hitTestResults.first(where: { $0.node.name == "boxNode" }) {
//            let distances = calculateDistances(to: result.node)
//            measurements.append(distances)
//            
//            if measurements.count >= 5 { // Take 5 measurements and then calculate the average
//                let averageDistances = calculateAverageDistances()
//                let calibratedDistance = calibrateDistance(averageDistances.total)
//                let rmse = calculateRMSE()
//                print("Average distance to the object: \(averageDistances.total) meters")
//                print("Calibrated distance: \(calibratedDistance) meters")
//                print("RMSE: \(rmse) meters")
//                print("Average distance along X: \(averageDistances.x) meters")
//                print("Average distance along Y: \(averageDistances.y) meters")
//                print("Average distance along Z: \(averageDistances.z) meters")
//                measurements.removeAll() // Clear the measurements after calculating the average
//            }
//        }
//    }
//
//    // Calculate the distances between the camera and the node along the X, Y, and Z axes
//    func calculateDistances(to node: SCNNode) -> (total: Float, x: Float, y: Float, z: Float) {
//        guard let cameraTransform = arView?.session.currentFrame?.camera.transform else { return (0, 0, 0, 0) }
//        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
//        let nodePosition = node.position
//        let distanceX = nodePosition.x - cameraPosition.x
//        let distanceY = nodePosition.y - cameraPosition.y
//        let distanceZ = nodePosition.z - cameraPosition.z
//        let totalDistance = sqrt(pow(distanceX, 2) + pow(distanceY, 2) + pow(distanceZ, 2))
//        return (totalDistance, distanceX, distanceY, distanceZ)
//    }
//
//    // Calculate the average distances from the measurements
//    func calculateAverageDistances() -> (total: Float, x: Float, y: Float, z: Float) {
//        let count = Float(measurements.count)
//        let sum = measurements.reduce((total: 0, x: 0, y: 0, z: 0)) { (result, measurement) in
//            return (result.total + measurement.total,
//                    result.x + measurement.x,
//                    result.y + measurement.y,
//                    result.z + measurement.z)
//        }
//        return (sum.total / count, sum.x / count, sum.y / count, sum.z / count)
//    }
//
//    // Calibrate the distance using a known value
//    func calibrateDistance(_ measuredDistance: Float) -> Float {
//        // Simple calibration formula, adjust as needed based on empirical data
//        let a: Float = 1.0
//        let b: Float = 0.0
//        return a * measuredDistance + b
//    }
//
//    // Calculate RMSE
//    func calculateRMSE() -> Float {
//        let sumOfSquares = measurements.reduce(Float(0)) { (result, measurement) in
//            let error = measurement.total - knownDistance
//            return result + pow(error, 2)
//        }
//        let meanSquareError = sumOfSquares / Float(measurements.count)
//        return sqrt(meanSquareError)
//    }
//
//    @ViewBuilder
//    @MainActor
//    func build(screen: AppScreenType) -> some View {
//        switch screen {
//        case .welcome:
//            WelcomeView()
//        case .signUp:
//            SignUpView(viewModel: LoginViewModel())
//        case .login:
//            LoginView(viewModel: LoginViewModel())
//        case .home:
//            HomeView().environmentObject(self)
//        case .selectBuilding:
//            SelectBuildingView()
//        case .ar:
//            MyARView()
//                .edgesIgnoringSafeArea(.all)
//        }
//    }
//}
