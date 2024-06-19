//
//  BaseCoordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//

import SwiftUI

class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var sheet: SheetType?
    
    
    func push(_ screen : AppScreenType) {
        path.append(screen);
    }
    
    func present(sheet: SheetType) {
        self.sheet = sheet;
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast();
    }
    
    func goToRoot() {
        path.removeLast(path.count);
    }
    
    func dismissSheet(){
        self.sheet = nil;
    }
    
    @MainActor
       @ViewBuilder
       func build(screen: AppScreenType) -> some View {
           NavigationView {
               switch screen {
               case .login:
                   LoginView(viewModel: LoginViewModel())
               case .home:
                   HomeView().environmentObject(self) // Inject the coordinator into HomeView
               case .selectBuilding:
                   SelectBuildingView()
               case .ar:
                   ARView(buildingName: "Afeka")
               }
           }
           .navigationBarHidden(true) // Hide the navigation bar
       }
    
//    @ViewBuilder
//    func build( sheet: SheetType ) -> some View {
//        switch sheet {
//            case .poiData:
//            
//        }
//    }
}



