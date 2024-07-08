//
//  StepCounterService.swift
//  Mapzin
//
//  Created by Amir Malamud on 07/07/2024.
//

import Foundation
import CoreMotion
import Combine

import Foundation
import CoreMotion
import Combine

protocol StepCounterServiceProtocol {
    var stepCountPublisher: Published<Int>.Publisher { get }
    var deviceMotionPublisher: Published<CMDeviceMotion?>.Publisher { get }
    func startCountingSteps()
    func stopCountingSteps()
}

class StepCounterService: StepCounterServiceProtocol, ObservableObject {
    private var pedometer = CMPedometer()
    private var motionManager = CMMotionManager()
    @Published var stepCount: Int = 0
    @Published var deviceMotion: CMDeviceMotion?
    
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }
    var deviceMotionPublisher: Published<CMDeviceMotion?>.Publisher { $deviceMotion }
    
    func startCountingSteps() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available.")
            return
        }
        
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self, error == nil, let data = data else {
                print("Error updating steps: \(String(describing: error))")
                return
            }
            
            DispatchQueue.main.async {
                self.stepCount = data.numberOfSteps.intValue
            }
        }
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                guard let self = self, error == nil, let motion = motion else {
                    print("Error updating device motion: \(String(describing: error))")
                    return
                }
                
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
}
