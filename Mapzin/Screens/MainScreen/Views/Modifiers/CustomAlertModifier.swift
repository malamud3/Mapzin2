//
//  CustomAlertModifier.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let errorMessage: String
    let dismissAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"), action: dismissAction)
                )
            }
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>, errorMessage: String, dismissAction: @escaping () -> Void) -> some View {
        self.modifier(CustomAlertModifier(isPresented: isPresented, errorMessage: errorMessage, dismissAction: dismissAction))
    }
}

