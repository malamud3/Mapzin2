//
//  ActionButtons.swift
//  Mapzin
//
//  Created by Amir Malamud on 25/05/2024.
//

import SwiftUI

struct ActionButtons: View {
    var openInMaps: () -> Void
    var startDirections: () -> Void
    
    var body: some View {
        HStack(spacing: 24) {
            Button(action: openInMaps) {
                Text("Open in Maps")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 170, height: 48)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(12)
            }
            .accessibilityLabel("Open in Maps")
            
            Button(action: startDirections) {
                Text("Get Directions")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 170, height: 48)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(12)
            }
            .accessibilityLabel("Get Directions")
        }
        .padding([.horizontal, .bottom])
    }
}

