//
//  SignUpButton.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import SwiftUI

struct SignUpButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Sign Up")
                .font(.headline)
                .foregroundColor(Color.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}
