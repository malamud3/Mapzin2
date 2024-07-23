//
//  CustomTextField.swift
//  Mapzin
//
//  Created by Amir Malamud on 16/06/2024.
//
import SwiftUI

public struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool
    var cornerRadius: CGFloat
    var padding: CGFloat
    var shadowColor: Color
    var shadowRadius: CGFloat
    var shadowX: CGFloat
    var shadowY: CGFloat
    var font: Font
    
    public init(placeholder: String,
                text: Binding<String>,
                isSecure: Bool = false,
                cornerRadius: CGFloat = 8,
                padding: CGFloat = 16,
                shadowColor: Color = Color.gray.opacity(0.3),
                shadowRadius: CGFloat = 4,
                shadowX: CGFloat = 0,
                shadowY: CGFloat = 2,
                font: Font = .body) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.font = font
    }
    
    public var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(font)
            } else {
                TextField(placeholder, text: $text)
                    .font(font)
            }
        }
        .padding(padding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
                .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
        )
    }
}

#Preview {
    CustomTextField(placeholder: "Placeholder", text: .constant(""))
}
