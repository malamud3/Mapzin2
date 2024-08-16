//
//  Building.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.
//


import SwiftUI
import MapKit

struct Building: Identifiable, Codable {
    let id: UUID
    let name: String
    let coordinates: CLLocationCoordinate2D
    let address: String?
    let floors: [Floor]
    
    init(name: String, imageName: String, coordinates: CLLocationCoordinate2D, address: String, floors: [Floor], link: String) {
         self.id = UUID()
         self.name = name
         self.coordinates = coordinates
         self.address = address
         self.floors = floors
     }
}

struct BuildingT: Identifiable {
    
    let id: Int
    let name: String
    let imageName: String
    
}
