//
//  BuildingCardView.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct BuildingCardView: View {
    let building: Building

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

struct BuildingCardView_Previews: PreviewProvider {
    static var previews: some View {
        let building = Building(name: "Building 1", imageName: "building1")
        BuildingCardView(building: building)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


