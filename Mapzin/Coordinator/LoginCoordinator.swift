//
//  LoginCoordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import SwiftUI
import Combine

@MainActor
class LoginCoordinator: ObservableObject {
    @Published var currentView: AnyView?

    private let loginViewModel: LoginViewModel

    init() {
        loginViewModel = LoginViewModel()

        loginViewModel.$isLoggedIn
            .sink { [weak self] isLoggedIn in
                if isLoggedIn {
                    self?.navigateToHome()
                }
            }
            .store(in: &loginViewModel.cancellables)  

        currentView = AnyView(LoginView(viewModel: loginViewModel))
    }

    func navigateToHome() {
        currentView = AnyView(HomeView())
    }
}

