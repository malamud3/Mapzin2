//
//  ErrorMessage.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import SwiftUI

struct ErrorMessage: View {
    let message: String
    
    var body: some View {
        if !message.isEmpty {
            Text(message)
                .foregroundColor(.red)
        }
    }
}

