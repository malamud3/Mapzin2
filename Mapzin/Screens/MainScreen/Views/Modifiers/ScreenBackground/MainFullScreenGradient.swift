//
//  MainFullScreenGradient.swift
//  Mapzin
//
//  Created by Amir Malamud on 19/06/2024.
//

import SwiftUI

struct MainFullScreenGradient: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.4),
                        Color.blue.opacity(0.3),
                        Color.green.opacity(0.2),
                        Color.green.opacity(0.1),
                        Color.white]
                                      ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func backgroundGradient() -> some View {
        self.modifier(MainFullScreenGradient())
    }
}

