//
//  LocationConstants.swift
//  Mapzin
//
//  Created by Amir Malamud on 26/05/2024.
//
import MapKit

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

