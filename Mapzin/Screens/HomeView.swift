import SwiftUI
import MapKit

struct HomeView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var showSearchResults = false

    @StateObject private var viewModel = SearchViewModel()
    
    @StateObject private var locationManager = LocationManager()
    
    // Add a state to manage the selected task
    @State private var selectedTask: TaskType? = nil

    var body: some View {
        ZStack(alignment: .top) {
            MapView(
                cameraPosition: $cameraPosition,
                mapSelection: $viewModel.mapSelection,
                results: $viewModel.results,
                route: $viewModel.route,
                routeDisplaying: $viewModel.routeDisplaying,
                routeDestination: $viewModel.routeDestination,
                userLocation: $locationManager.userLocation
            )

            VStack {
                HStack {
                    Spacer()
                    SearchBar(searchText: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { oldValue, newValue in
                            viewModel.triggerSearch()
                            showSearchResults = !newValue.isEmpty && !viewModel.results.isEmpty
                        }
                    
                    Menu {
                        Button("Task 1", action: { handleTask(.task1) })
                        Button("Task 2", action: { handleTask(.task2) })
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.trailing, 16)
                }


                if showSearchResults {
                    SearchResultsList(results: $viewModel.results, mapSelection: $viewModel.mapSelection) {
                        showSearchResults = false
                    }
                }
            }
        }
        .onAppear {
            locationManager.startUpdatingLocation()
        }
        .onChange(of: viewModel.searchText) { oldValue, newValue in
            viewModel.triggerSearch()
        }
        .onChange(of: getDirections) { oldValue, newValue in
            if newValue {
                viewModel.fetchRoute(from: .userLocation)
            }
        }
        .onChange(of: viewModel.mapSelection) { oldValue, newValue in
            showDetails = newValue != nil
        }
        .sheet(isPresented: $showDetails) {
            if viewModel.mapSelection != nil {
                LocationDetailsView(
                    mapSelection: $viewModel.mapSelection,
                    show: $showDetails,
                    getDirections: $getDirections
                )
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
                .padding()
            }
        }
    }
    
    private func handleTask(_ task: TaskType) {
        // Handle task selection
        selectedTask = task
        // Perform task-specific actions here
        switch task {
        case .task1:
            print("Task 1 selected")
            // Add task 1 specific logic
        case .task2:
            print("Task 2 selected")
            // Add task 2 specific logic
        }
    }
}

enum TaskType {
    case task1, task2
}
