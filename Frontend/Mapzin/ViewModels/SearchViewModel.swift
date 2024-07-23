//
//  SearchViewModel.swift
//  Mapzin
//
//  Created by Amir Malamud on 25/05/2024.
//

import SwiftUI
import MapKit
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [MKMapItem] = []
    @Published var mapSelection: MKMapItem? = nil
    @Published var isSearching: Bool = false
    @Published var errorMessage: String? = nil
    @Published var route: MKRoute?
    @Published var routeDisplaying: Bool = false
    @Published var routeDestination: MKMapItem?

    private var cancellable: AnyCancellable?

    init() {
        cancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
    }

    func triggerSearch() {
        performSearch(query: searchText)
    }

    private func performSearch(query: String) {
        guard !query.isEmpty else {
            results = []
            return
        }

        isSearching = true
        errorMessage = nil

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            DispatchQueue.main.async {
                self?.isSearching = false
                if let error = error {
                    self?.results = []
                    self?.errorMessage = error.localizedDescription
                } else if let response = response {
                    self?.results = response.mapItems
                } else {
                    self?.results = []
                    self?.errorMessage = "No results found."
                }
            }
        }
    }

    func fetchRoute(from source: CLLocationCoordinate2D) {
        guard let destination = mapSelection else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: source))
        request.destination = destination

        Task {
            do {
                let result = try await MKDirections(request: request).calculate()
                DispatchQueue.main.async {
                    self.route = result.routes.first
                    self.routeDestination = destination
                    self.routeDisplaying = true
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error fetching route: \(error)")
                }
            }
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
