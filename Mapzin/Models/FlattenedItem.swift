//
//  FlattenedItem.swift
//  Mapzin
//
//  Created by Amir Malamud on 28/08/2024.
//

import Foundation
struct FlattenedItem: Identifiable {
    let id = UUID()
    let title: String
    let parentTitle: String
}
