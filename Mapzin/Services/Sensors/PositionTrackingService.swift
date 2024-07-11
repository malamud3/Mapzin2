//import SwiftUI
//import ARKit
//import CoreMotion
//import Combine
//
//class PositionTrackingService: NSObject, ObservableObject, ARSessionDelegate {
//    @Published var stepCount: Int = 0
//    @Published var deviceMotion: CMDeviceMotion?
//    @Published var currentPosition: SIMD3<Float> = [0, 0, 0]
//    @Published var angleInDegrees: Float = 0
//    @Published var odometer: Double = 0
//    @Published var distanceX: Float = 0
//    @Published var distanceY: Float = 0
//    @Published var distanceZ: Float = 0
//
//    private var arSession: ARSession!
//    private var motionManager = CMMotionManager()
//    private var pedometer = CMPedometer()
//    private var lastHeading: Double = 0.0
//    private var stepLength: Double = 0.78 // Average step length in meters, adjust as needed
//    private var arPosition: SIMD3<Float> = [0, 0, 0]
//    private var kalmanFilter: KalmanFilter!
//
//    override init() {
//        super.init()
//        arSession = ARSession()
//        arSession.delegate = self
//        kalmanFilter = KalmanFilter(stateDim: 3, measDim: 3)
//        startARSession()
//    }
//
//    private func startARSession() {
//        let configuration = ARWorldTrackingConfiguration()
//        arSession.run(configuration)
//    }
//
//    func startTracking() {
//        guard CMPedometer.isStepCountingAvailable() else { return }
//
//        pedometer.startUpdates(from: Date()) { [weak self] data, error in
//            guard let self = self, let data = data, error == nil else { return }
//            DispatchQueue.main.async {
//                self.stepCount = data.numberOfSteps.intValue
//                self.updatePosition(with: data.numberOfSteps.intValue)
//                self.updateOdometer(with: data.distance?.doubleValue ?? 0.0)
//            }
//        }
//
//        guard motionManager.isDeviceMotionAvailable else { return }
//
//        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
//        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
//            guard let self = self, let motion = motion, error == nil else { return }
//            DispatchQueue.main.async {
//                self.deviceMotion = motion
//                self.lastHeading = motion.heading
//                self.updateAngleInDegrees(with: motion.attitude)
//                self.fuseSensors()
//            }
//        }
//    }
//
//    private func updatePosition(with steps: Int) {
//        let distance = Double(steps) * stepLength
//        let deltaX = distance * cos(lastHeading)
//        let deltaY = distance * sin(lastHeading)
//        
//        currentPosition += [Float(deltaX), 0, Float(deltaY)]
//        distanceX += Float(deltaX)
//        distanceY += 0 // Assuming no vertical movement for simplicity
//        distanceZ += Float(deltaY)
//        fuseSensors()
//    }
//
//    private func updateAngleInDegrees(with attitude: CMAttitude) {
//        let yawInDegrees = Float(attitude.yaw) * 180.0 / .pi
//        angleInDegrees = yawInDegrees
//    }
//
//    private func updateOdometer(with distance: Double) {
//        odometer += distance
//    }
//
//    func stopTracking() {
//        pedometer.stopUpdates()
//        motionManager.stopDeviceMotionUpdates()
//    }
//    
//    deinit {
//        stopTracking()
//    }
//    
//    func getCylindricalCoordinates() -> (r: Float, theta: Float, z: Float) {
//        let x = currentPosition.x
//        let y = currentPosition.z
//        let r = sqrt(x * x + y * y)
//        let theta = atan2(y, x) * 180.0 / .pi
//        let z = currentPosition.y
//        return (r, theta, z)
//    }
//
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        arPosition = frame.camera.transform.translation
//        fuseSensors()
//    }
//
//    private func fuseSensors() {
//        let arPositionArray = [arPosition.x, arPosition.y, arPosition.z]
//        let currentPositionArray = [currentPosition.x, currentPosition.y, currentPosition.z]
//
//        kalmanFilter.predict()
//        kalmanFilter.update(measurement: arPositionArray)
//        kalmanFilter.update(measurement: currentPositionArray)
//
//        let fusedState = kalmanFilter.state
//        currentPosition = SIMD3<Float>(fusedState[0], fusedState[1], fusedState[2])
//        
//        distanceX = fusedState[0]
//        distanceY = fusedState[1]
//        distanceZ = fusedState[2]
//    }
//}
//
//extension simd_float4x4 {
//    var translation: SIMD3<Float> {
//        let translation = columns.3
//        return SIMD3<Float>(translation.x, translation.y, translation.z)
//    }
//}
//
//class KalmanFilter {
//    var state: [Float]
//    var covariance: [[Float]]
//    let processNoise: [[Float]]
//    let measurementNoise: [[Float]]
//    var identity: [[Float]]
//
//    init(stateDim: Int, measDim: Int) {
//        state = [Float](repeating: 0.0, count: stateDim)
//        covariance = Array(repeating: Array(repeating: 0.0, count: stateDim), count: stateDim)
//        processNoise = Array(repeating: Array(repeating: 1.0, count: stateDim), count: stateDim)
//        measurementNoise = Array(repeating: Array(repeating: 1.0, count: measDim), count: measDim)
//        identity = Array(repeating: Array(repeating: 0.0, count: stateDim), count: stateDim)
//        for i in 0..<stateDim {
//            identity[i][i] = 1.0
//        }
//    }
//
//    func predict() {
//        // Predict the next state (basic prediction step, can be extended with control input)
//        // Here, we assume a simple constant velocity model for the prediction step
//    }
//
//    func update(measurement: [Float]) {
//        // Update the state with the new measurement using the Kalman gain
//        // This example assumes direct measurement of the state
//        let y = measurement
//        let s = measurementNoise
//        let k = covariance // Simplified Kalman gain (in reality, should be more complex)
//        
//        // Update state and covariance
//        for i in 0..<state.count {
//            state[i] = state[i] + k[i][i] * (y[i] - state[i])
//            for j in 0..<state.count {
//                covariance[i][j] = (identity[i][j] - k[i][j]) * covariance[i][j]
//            }
//        }
//    }
//}
