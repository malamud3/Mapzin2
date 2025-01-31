//
//  SignUpView.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject var viewModel = LoginViewModel()
    @State private var errorMessagePresented = false
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 10)
            
            VStack(spacing: 20) {
                CustomTextField(placeholder: "Email", text: $viewModel.email)
                CustomTextField(placeholder: "Password", text: $viewModel.password, isSecure: true)
                
                SignUpButton(
                    action: {
                        viewModel.signUp()
                        if viewModel.isLoggedIn {
                            coordinator.push(.home)
                        }
                    }
                )
                
                Button(action: {
                    coordinator.push(.login)
                }) {
                    Text("Already have an account? Login")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
        }
        .backgroundGradient()
        .alert(isPresented: $errorMessagePresented) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK")) {
                    viewModel.errorMessage = ""
                }
            )
        }
        .onReceive(viewModel.$errorMessage) { errorMessage in
            DispatchQueue.main.async {
                if !errorMessage.isEmpty {
                    errorMessagePresented = true
                }
            }
        }
        .preferredColorScheme(.light)
    }
}
