//
//  SelectBuilding.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//


import SwiftUI


struct SelectBuildingView: View {
    
    @EnvironmentObject var coordinator: Coordinator;
    @State private var searchText = "";
    
    let buildings = [
        Building(name: "Afeka", imageName: "AfekaLogo"),
        Building(name: "Building 2", imageName: "TelAvivLogo"),
        Building(name: "Building 3", imageName: "BGLogo")
    ];
    
    var filteredBuildings: [Building] {
        if searchText.isEmpty {
            return buildings
        } else {
            return buildings.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    };
    
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
                                if(building.name == "Afeka"){
                                    coordinator.push(.ar);
                                }
                               }
                    }
                }
                .padding(40);

            }
        }
        .backgroundGradient();
    };
}

#Preview {
    SelectBuildingView()
}
