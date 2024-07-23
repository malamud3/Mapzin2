//
//  Screens.swift
//  Mapzin
//
//  Created by Amir Malamud on 18/06/2024.
//


enum AppScreenType: String , Identifiable {
    
    case login
    case signUp
    case welcome
    case home
    case selectBuilding
    case ar
    
    
    var id: String {
        self.rawValue
    }
}
