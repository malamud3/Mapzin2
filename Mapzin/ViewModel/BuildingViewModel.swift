//
//  BuildingViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.
//



import SwiftUI
import Combine

protocol BuildingProvider {
    var buildings: [Building] { get }
}

class BuildingViewModel: ObservableObject, BuildingProvider {
    @Published var buildings: [Building] = []

    init(buildings: [Building]) {
        self.buildings = buildings
    }
}

