//
//  SheetType.swift
//  Mapzin
//
//  Created by Amir Malamud on 07/07/2024.
//

enum SheetType: String, Identifiable {
   case poiData
    var id: String {
        self.rawValue
    }
}

