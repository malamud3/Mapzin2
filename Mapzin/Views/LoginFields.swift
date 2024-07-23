//
//  LoginFields.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import SwiftUI

struct LoginFields: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }
}

