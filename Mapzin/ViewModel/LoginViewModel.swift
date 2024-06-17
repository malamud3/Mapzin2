//
//  LoginViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoggedIn = false
    
    private var authProvider: FirebaseAuthProvider
    var cancellables = Set<AnyCancellable>()
    
    init(authProvider: FirebaseAuthProvider = FirebaseAuthProvider()) {
        self.authProvider = authProvider
    }

    func login() {
        Task {
            for await result in authProvider.signIn(withEmail: email, password: password) {
                switch result {
                case .failure(let error):
                    errorMessage = error.localizedDescription
                case .success:
                    isLoggedIn = true
                }
            }
        }
    }

    func signUp() {
        Task {
            for await result in authProvider.createUser(withEmail: email, password: password) {
                switch result {
                case .failure(let error):
                    errorMessage = error.localizedDescription
                case .success:
                    isLoggedIn = true
                }
            }
        }
    }
}
