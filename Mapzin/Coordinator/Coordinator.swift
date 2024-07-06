//
//  BaseCoordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//

import SwiftUI
import ARKit


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
    
    @ViewBuilder
    @MainActor
    func build(screen: AppScreenType) -> some View {
        NavigationView {
            switch screen {
                
            case .welcome:
                WelcomeView()
            case .signUp:
                SignUpView(viewModel: LoginViewModel())
            case .login:
                LoginView(viewModel: LoginViewModel())
            case .home:
                HomeView()
                    .environmentObject(self)
            case .selectBuilding:
                SelectBuildingView()
            case .ar:
                MyARView(buildingName: "Afeka")
                    .edgesIgnoringSafeArea(.all)
                
            }
        }
        // Hide the navigation bar
    }
    
    //    @ViewBuilder
    //    func build( sheet: SheetType ) -> some View {
    //        switch sheet {
    //            case .poiData:
    //
    //        }
    //    }
}



