//
//  LocationViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

//import Foundation
//import CoreLocation


//@Observable
//class LocationManager: NSObject, CLLocationManagerDelegate {
//
//   @ObservationIgnored  private let locationManager = CLLocationManager()
//     var userLocation: CLLocation?;
//     var isAuthorized = true;
//
//    override init(){
//        super.init();
//        locationManager.delegate = self
//        startLocationServices()
//    }
//
//        func startLocationServices(){
//            if locationManager.authorizationStatus == .authorizedAlways ||
//                locationManager.authorizationStatus == .authorizedWhenInUse{
//                    locationManager.startUpdatingLocation();
//                    isAuthorized = true;
//            } else {
//                isAuthorized = false ;
//                locationManager.requestWhenInUseAuthorization();
//            }
//        }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        userLocation = locations.last;
//    }
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch locationManager.authorizationStatus {
//            case .authorizedAlways,.authorizedWhenInUse:
//                isAuthorized = true;
//                locationManager.requestLocation();
//            case .notDetermined:
//                isAuthorized = false;
//                locationManager.requestWhenInUseAuthorization();
//            case .denied:
//                isAuthorized = false;
//            print("Access Denied");
//            default:
//                isAuthorized = true;
//                startLocationServices();
//
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
//        print(error.localizedDescription);
//    }
//
//}

import Foundation
import CoreLocation
import Combine
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocation?
    @Published var isAuthorized = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        checkAuthorizationStatus()
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocationAuthorization() {
        print("Requesting location authorization")
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func checkAuthorizationStatus() {
        
        print("Checking authorization status")
        authorizationStatus = locationManager.authorizationStatus
        print("Initial authorization status: \(authorizationStatus.rawValue)")
        handleAuthorizationStatus(authorizationStatus)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization status changed")
        authorizationStatus = manager.authorizationStatus
        print("New authorization status: \(authorizationStatus.rawValue)")
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
                print("Location access denied or restricted")
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
        print(#function, authorizationStatus)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
