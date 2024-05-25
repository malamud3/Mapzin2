//
//  LoginViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import Foundation
import FirebaseAuth
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoggedIn = false
    internal var cancellables = Set<AnyCancellable>()

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.isLoggedIn = true
            }         
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.isLoggedIn = true
            }
        }
    }
}

