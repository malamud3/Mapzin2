//
//  LocationViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import CoreLocation
import Combine
import SwiftUI

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocation?
    @Published var isAuthorized = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request location authorization on the main thread
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        checkAuthorizationStatus()
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocationAuthorization() {
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func checkAuthorizationStatus() {
        authorizationStatus = locationManager.authorizationStatus
        handleAuthorizationStatus(authorizationStatus)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        handleAuthorizationStatus(authorizationStatus)
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.isAuthorized = true
                self.startLocationUpdates()
            }
        case .notDetermined:
            requestLocationAuthorization()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.isAuthorized = false
                self.stopLocationUpdates()
            }
        @unknown default:
            DispatchQueue.main.async {
                self.isAuthorized = false
                self.stopLocationUpdates()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.userLocation = locations.last
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("Location access denied by the user.")
            case .locationUnknown:
                print("Location could not be determined.")
            default:
                print("Location error: \(clError.code.rawValue)")
            }
        }
    }
}
