//
//  CoordinatorView.swift
//  Mapzin
//
//  Created by Amir Malamud on 18/06/2024.
//

import SwiftUI

struct CoordinatorView: View {
    
    
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        
        NavigationStack(path: $coordinator.path) {
            
            coordinator.build(screen : .login)
                .navigationDestination(for: AppScreenType.self) { screen in
                    coordinator.build(screen: screen)
                }
//                .sheet(isPresented: $coordinator, content: { sheet in
//                    coordinator.build(sheet: sheet)
//                })

        }
        .navigationBarHidden(true)
        .environmentObject(coordinator);
    }
}
extension UINavigationController {
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal

  }
}
