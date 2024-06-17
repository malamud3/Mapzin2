//
//  KeyboardAvoider.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//

import SwiftUI
import Combine

struct KeyboardAvoider: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    @State private var isKeyboardVisible = false
    @State private var cancellables: Set<AnyCancellable> = []

    func body(content: Content) -> some View {
        content
            .padding(.bottom, isKeyboardVisible ? keyboardHeight : 0)
            .onAppear(perform: subscribeToKeyboardEvents)
            .onDisappear(perform: unsubscribeFromKeyboardEvents)
    }

    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .sink { rect in
                self.keyboardHeight = rect.height
                self.isKeyboardVisible = true
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { _ in
                self.isKeyboardVisible = false
            }
            .store(in: &cancellables)
    }

    private func unsubscribeFromKeyboardEvents() {
        cancellables.forEach { $0.cancel() }
    }
}

extension View {
    func keyboardAvoiding() -> some View {
        self.modifier(KeyboardAvoider())
    }
}
