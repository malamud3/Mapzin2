//
//  LookAroundPreviewView.swift
//  Mapzin
//
//  Created by Amir Malamud on 25/05/2024.
//

import SwiftUI
import MapKit

struct LookAroundPreviewView: View {
    @Binding var lookAroundScene: MKLookAroundScene?
    
    var body: some View {
        Group {
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
                    .padding()
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
        .animation(.easeInOut, value: lookAroundScene)
    }
}

