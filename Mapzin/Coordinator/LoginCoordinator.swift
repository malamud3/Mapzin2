//
//  LoginCoordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import SwiftUI
import Combine

class LoginCoordinator: ObservableObject {
    @Published var currentView: AnyView?

    private let loginViewModel: LoginViewModel

    init() {
        loginViewModel = LoginViewModel()

        
        // Observe when the user is logged in and navigate accordingly
        loginViewModel.$isLoggedIn
            .sink { [weak self] isLoggedIn in
                if isLoggedIn {
                    self?.navigateToHome()
                }
            }
            .store(in: &loginViewModel.cancellables)  

        // Default view is the login view
        currentView = AnyView(LoginView(viewModel: loginViewModel))
    }

    func navigateToHome() {
        currentView = AnyView(HomeView()) // Define your HomeView elsewhere
    }
}

