//
//  Location.swift
//  Mapzin
//
//  Created by Amir Malamud on 30/05/2024.
//

import Foundation
import MapKit

//Equatable
struct Location: Identifiable  {
    
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageName: [String]
    let link: String
    
    
    //Identifiable
    var id: String {
        name + cityName
    }
    
//    //Equatable
//    static func == (lhs: Location, rhs: Location) -> Bool {
//        <#code#>
//    }  
}
