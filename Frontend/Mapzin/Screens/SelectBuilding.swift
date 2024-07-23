//
//  SelectBuilding.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//


import SwiftUI


struct SelectBuildingView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var searchText = ""

    let buildings = [
        BuildingT(id: 1, name: "Afeka", imageName: "AfekaLogo"),
        BuildingT(id: 2, name: "Building 2", imageName: "TelAvivLogo"),
        BuildingT(id: 3, name: "Building 3", imageName: "BGLogo")
    ]

    var filteredBuildings: [BuildingT] {
        if searchText.isEmpty {
            return buildings
        } else {
            return buildings.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)
                .padding(.horizontal)
                .padding(.top, 70)
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredBuildings) { building in
                        BuildingCardView(building: building)
                            .onTapGesture {
                                if building.name == "Afeka" {
                                    coordinator.push(.ar)
                                }
                            }
                    }
                }
                .padding(40)
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    SelectBuildingView()
}
