//
//  LoginCoordinator.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//




import SwiftUI
import Combine

// MARK: - Deprecated

//@available(*, deprecated, message: "Use new Coordinator Method instead")
//@MainActor
//class LoginCoordinator: ObservableObject {
//    @Published var currentView: AnyView
//     var loginViewModel: LoginViewModel
//
//    init() {
//        self.loginViewModel = LoginViewModel()
//        self.currentView = AnyView(LoginView(viewModel: loginViewModel))
//
//        loginViewModel.$isLoggedIn
//            .sink { [weak self] isLoggedIn in
//                self?.handleLoginStateChange(isLoggedIn)
//            }
//            .store(in: &loginViewModel.cancellables)
//    }
//
//    private func handleLoginStateChange(_ isLoggedIn: Bool) {
//        if isLoggedIn {
//            navigateToHome()
//        } else {
//            currentView = AnyView(LoginView(viewModel: loginViewModel))
//        }
//    }
//
//    private func navigateToHome() {
//        currentView = AnyView(HomeView())
//    }
//}
//
