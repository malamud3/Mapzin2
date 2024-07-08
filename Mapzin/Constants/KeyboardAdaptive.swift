//
//  KeyboardAvoider.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//

import SwiftUI


struct KeyboardAdaptive: ViewModifier {
    @ObservedObject var keyboard = KeyboardObserver()
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboard.keyboardHeight)
            .onReceive(keyboard.$keyboardHeight) { _ in
                withAnimation(.easeOut(duration: 0.16)) {
                    // Trigger view update
                }
            }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        self.modifier(KeyboardAdaptive())
    }
}

