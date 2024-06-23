//
//  MapzinApp.swift
//  Mapzin
//
//  Created by Amir Malamud on 17/03/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

//@main
//struct MapzinApp: App {
//  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @State private var locationManager = LocationManager();
//
//  var body: some Scene {
//    WindowGroup {
//        if locationManager.isAuthorized{
//            CoordinatorView();
//        }else{
//            Text("Need to help user");
//        }
//    }
//  }
//}

@main
struct MapzinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
        }
    }
}
