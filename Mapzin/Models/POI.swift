//
//  POI.swift
//  Mapzin
//
//  Created by Amir Malamud on 07/06/2024.
//

import Foundation
import MapKit

struct POI: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
