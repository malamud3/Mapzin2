//
//  ContentView.swift
//  Mapzin
//
//  Created by Amir Malamud on 17/03/2024.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var showSearchResults = false

    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            MapView(
                cameraPosition: $cameraPosition,
                mapSelection: $viewModel.mapSelection,
                results: $viewModel.results,
                route: $viewModel.route,
                routeDisplaying: $viewModel.routeDisplaying,
                routeDestination: $viewModel.routeDestination
            )

            VStack {
                SearchBar(searchText: $viewModel.searchText)
                    .onChange(of: viewModel.searchText) { oldValue, newValue in
                        viewModel.triggerSearch()
                        showSearchResults = !newValue.isEmpty && !viewModel.results.isEmpty
                    }

                if showSearchResults {
                    SearchResultsList(results: $viewModel.results, mapSelection: $viewModel.mapSelection) {
                        showSearchResults = false
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
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
}
