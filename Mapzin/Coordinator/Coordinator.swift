
import SwiftUI
import ARKit

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: SheetType?

    func push(_ screen: AppScreenType) {
        path.append(screen)
    }

    func present(sheet: SheetType) {
        self.sheet = sheet
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func goToRoot() {
        path.removeLast(path.count)
    }

    func dismissSheet() {
        self.sheet = nil
    }

    @ViewBuilder
    @MainActor
    func build(screen: AppScreenType) -> some View {
        switch screen {
        case .welcome:
            WelcomeView()
        case .signUp:
            SignUpView(viewModel: LoginViewModel())
        case .login:
            LoginView(viewModel: LoginViewModel())
        case .home:
            HomeView()
        case .selectBuilding:
            SelectBuildingView()
        case .ar:
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
