//
//  AuthButton.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import SwiftUI

struct LoginButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Log In")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(10)
                .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 2)
        }
    }
}
