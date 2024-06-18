//
//  SelectBuilding.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//


import SwiftUI

struct SelectBuildingView: View {
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Select a Building")
                .font(.largeTitle)
            
            // Add your SelectBuilding content here
            
            Button(action: {
//                coordinator.navigateTo(.home)
            }) {
                Text("Back to Home")
            }
        }
        .padding()
    }
}

