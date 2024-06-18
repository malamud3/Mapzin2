//
//  CenterButton.swift
//  Mapzin
//
//  Created by Amir Malamud on 26/05/2024.
//

import SwiftUI

struct CenterButton: View {
    let action: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
            .padding()
        }
    }
}

