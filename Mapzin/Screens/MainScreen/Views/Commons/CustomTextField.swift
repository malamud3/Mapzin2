//
//  CustomTextField.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//
import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
        )
        .colorScheme(.light)
    }
}

