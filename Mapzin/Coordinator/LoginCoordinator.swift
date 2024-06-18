//
//  LoginCoordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

@MainActor
class LoginCoordinator: ObservableObject {
    @Published var currentView: AnyView
    private var loginViewModel: LoginViewModel

    init() {
        self.loginViewModel = LoginViewModel()
        self.currentView = AnyView(LoginView(viewModel: loginViewModel))

        loginViewModel.$isLoggedIn
            .sink { [weak self] isLoggedIn in
                self?.handleLoginStateChange(isLoggedIn)
            }
            .store(in: &loginViewModel.cancellables)
    }

    private func handleLoginStateChange(_ isLoggedIn: Bool) {
        if isLoggedIn {
            navigateToHome()
        } else {
            currentView = AnyView(LoginView(viewModel: loginViewModel))
        }
    }

    private func navigateToHome() {
        currentView = AnyView(HomeView())
    }
}
