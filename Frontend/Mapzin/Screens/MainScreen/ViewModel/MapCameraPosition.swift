//
//  MapCameraPosition.swift
//  Mapzin
//
//  Created by Amir Malamud on 25/05/2024.
//

import MapKit

enum MapCameraPosition {
    case region(MKCoordinateRegion)
    case rect(MKMapRect)
}

