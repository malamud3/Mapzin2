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
        CustomButton(
            title: "Log In",
            titleColor: .white,
            backgroundColor: LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .leading,
                endPoint: .trailing
            ),
            borderColor: nil,
            action: action
        )
    }
}
