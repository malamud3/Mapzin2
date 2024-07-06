//
//  WelcomeView.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack {
            VStack() {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 10)
                
                VStack(spacing: 20) {
                    LoginButton {
                        coordinator.push(.login)
                    }
                    
                    SignUpButton {
                        coordinator.push(.signUp)
                    }
                    
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                
            }
        }
        .backgroundGradient()
        .preferredColorScheme(.light)
    }
    
}

#Preview {
    WelcomeView()
}
