//
//  HomeViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 17/03/2024.
//

import Foundation
import MapKit
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var cameraPosition: MapCameraPosition = .region(.userRegion)
    @Published var searchText = ""
    @Published var results = [MKMapItem]()
    @Published var mapSelection: MKMapItem?
    @Published var showDetails = false
    @Published var getDirections = false
    
    @Published var routeDisplaying = false
    @Published var route: MKRoute?
    @Published var routeDestination: MKMapItem?
    
    private let locationManager = CLLocationManager()
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
    
    func fetchRoute() {
        if let mapSelection = mapSelection {
            let req = MKDirections.Request()
            req.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            req.destination = mapSelection
            
            Task {
                let result = try? await MKDirections(request: req).calculate()
                route = result?.routes.first
                routeDestination = mapSelection
                
                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                    
                    if let rect = route?.polyline.boundingMapRect {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}

extension Animation {
    static var snappy: Animation {
        Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 32.1226, longitude: 34.8065)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}
