//
//  Screens.swift
//  Mapzin
//
//  Created by Amir Malamud on 18/06/2024.
//

import Foundation


enum AppScreenType: String , Identifiable {
    
    case login
    case home
    case selectBuilding
    case ar
    
    var id: String {
        self.rawValue
    }
}

enum SheetType: String, Identifiable {
   case poiData
    var id: String {
        self.rawValue
    }
}
