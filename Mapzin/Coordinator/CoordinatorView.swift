//
//  CoordinatorView.swift
//  Mapzin
//
//  Created by Amir Malamud on 18/06/2024.
//

import SwiftUI

//struct CoordinatorView: View {
//    
//    
//    @StateObject private var coordinator = Coordinator()
//    @StateObject private var locationManager = LocationManager()
//
//    var body: some View {
//        
//        NavigationStack(path: $coordinator.path) {
//            
//            coordinator.build(screen : .login)
//                .navigationDestination(for: AppScreenType.self) { screen in
////                    if locationManager.authorizationStatus == .notDetermined {
////                        Text("Determining location authorization status...")
////                    }else if locationManager.isAuthorized {
//                        coordinator.build(screen: screen)
////                    }else {
////                        Text("Location access is required to use this app. Please enable it in Settings.")
////                    }
//                }
////                .sheet(isPresented: $coordinator, content: { sheet in
////                    coordinator.build(sheet: sheet)
////                })
//
//        }
//        .navigationBarHidden(true)
//        .environmentObject(coordinator)
//        .environmentObject(locationManager)
//
//        
//    }
//}
//
//extension UINavigationController {
//  open override func viewWillLayoutSubviews() {
//    super.viewWillLayoutSubviews()
//    navigationBar.topItem?.backButtonDisplayMode = .minimal
//
//  }
//}
import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: .welcome)
                .navigationDestination(for: AppScreenType.self) { screen in
                    if locationManager.authorizationStatus == .notDetermined {
                        Text("Determining location authorization status...")
                    } else if locationManager.isAuthorized {
                        coordinator.build(screen: screen)
                            .navigationBarHidden(true)
                    } else {
                        Text("Location access is required to use this app. Please enable it in Settings.")
                    }
                }
        }
        .environmentObject(coordinator)
        .environmentObject(locationManager)
    }
}
