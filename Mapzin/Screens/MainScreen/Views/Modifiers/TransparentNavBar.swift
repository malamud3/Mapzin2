//
//  TransparentNavigationBarModifier.swift
//  Mapzin
//
//  Created by Amir Malamud on 18/06/2024.
//


import SwiftUI

struct TransparentNavBar: ViewModifier {
    init() {
        // Customize the appearance of the navigation bar
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = .clear
    }

    func body(content: Content) -> some View {
        content
    }
}

