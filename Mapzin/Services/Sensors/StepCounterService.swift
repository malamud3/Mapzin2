import Combine
import CoreMotion

class StepCounterService: ObservableObject {
    @Published var stepCount: Int = 0
    @Published var deviceMotion: CMDeviceMotion?

    private let motionManager = CMMotionManager()
    private var pedometer = CMPedometer()

    func startCountingSteps() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available on this device.")
            return
        }
        
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                print("Pedometer error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.stepCount = data.numberOfSteps.intValue
                }
            }
        }

        startDeviceMotionUpdates()
    }

    private func startDeviceMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available on this device.")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self else { return }
            if let error = error {
                print("Device motion error: \(error.localizedDescription)")
                return
            }
            if let motion = motion {
                DispatchQueue.main.async {
                    self.deviceMotion = motion
                }
            }
        }
    }

    func stopCountingSteps() {
        pedometer.stopUpdates()
        motionManager.stopDeviceMotionUpdates()
    }
    
    deinit {
        stopCountingSteps()
    }
}
