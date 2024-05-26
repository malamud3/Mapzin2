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

               if !viewModel.results.isEmpty {
                   SearchResultsList(results: $viewModel.results, mapSelection: $viewModel.mapSelection)
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
extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 32.1226, longitude: 34.8065)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}
