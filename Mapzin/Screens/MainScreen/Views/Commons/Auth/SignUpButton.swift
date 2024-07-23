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
        CustomButton(
            title: "Sign Up",
            titleColor: Color.blue,
            backgroundColor: LinearGradient(colors: [Color.white, Color.white], startPoint: .leading, endPoint: .trailing),
            borderColor: LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .leading,
                endPoint: .trailing
            ),
            action: action
        )
    }
}
