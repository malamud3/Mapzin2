//
//  LoginViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoggedIn = false
    
    private var authProvider: FirebaseAuthService
    var cancellables = Set<AnyCancellable>()
    
    init(authProvider: FirebaseAuthService = FirebaseAuthService()) {
        self.authProvider = authProvider
    }

    func login() {
        Task(priority: .userInitiated) {
            for await result in authProvider.signIn(withEmail: email, password: password) {
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                case .success:
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                    }
                }
            }
        }
    }

    func signUp() {
        Task(priority: .userInitiated) {
            for await result in authProvider.createUser(withEmail: email, password: password) {
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                case .success:
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                    }
                }
            }
        }
    }
}
