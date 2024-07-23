//
//  CustomButton.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let titleColor: Color
    let backgroundColor: LinearGradient?
    let borderColor: LinearGradient?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(titleColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor ?? LinearGradient(
                            colors: [Color.clear],
                            startPoint: .leading, endPoint: .trailing), lineWidth: borderColor != nil ? 2 : 0)
                )
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}
