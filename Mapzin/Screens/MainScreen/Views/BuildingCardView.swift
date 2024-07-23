//
//  BuildingCardView.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.
//

import SwiftUI


struct BuildingCardView: View {
    let building: BuildingT

    var body: some View {
        HStack(spacing: 10) {
            
            
            Image(building.imageName)
                .resizable()
                .frame(
                    width: 340,
                    height: 80
                )
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
                .shadow(radius: 5)

        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
