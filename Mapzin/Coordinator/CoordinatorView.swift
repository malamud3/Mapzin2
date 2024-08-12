import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    @StateObject private var locationManager = LocationService()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: .ar)
                .navigationDestination(for: AppScreenType.self) { screen in
                    if locationManager.authorizationStatus == .notDetermined {
                        Text("Determining location authorization status...")
                    } else if locationManager.isAuthorized {
                        coordinator.build(screen: screen)
                            .navigationBarHidden(true)
                    } else {
                        Text("Location access is required to use this app. Please enable it in Settings.")
                    }
                }
        }
        .environmentObject(coordinator)
        .environmentObject(locationManager)
    }
}
