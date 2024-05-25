//
//  UserAnnotation.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import SwiftUI

struct UserAnnotation: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundColor(.blue.opacity(0.25))
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            Circle()
                .frame(width: 12, height: 12)
                .foregroundColor(.blue)
        }
    }
}

