//
//  SearchBarTests.swift
//  MapzinTests
//
//  Created by Amir Malamud on 28/07/2024.
//

import XCTest
import MapKit
import Combine
@testable import Mapzin

class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertTrue(viewModel.results.isEmpty)
        XCTAssertNil(viewModel.mapSelection)
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.route)
        XCTAssertFalse(viewModel.routeDisplaying)
        XCTAssertNil(viewModel.routeDestination)
    }

    func testTriggerSearchWithEmptyQuery() {
        viewModel.searchText = ""
        viewModel.triggerSearch()
        XCTAssertTrue(viewModel.results.isEmpty)
        XCTAssertFalse(viewModel.isSearching)
    }

    func testTriggerSearchWithValidQuery() {
        let expectation = self.expectation(description: "Search should return results")
        viewModel.searchText = "coffee shop"

        viewModel.$results
            .dropFirst()
            .sink { results in
                XCTAssertFalse(results.isEmpty, "Search results should not be empty.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.triggerSearch()

        waitForExpectations(timeout: 5, handler: nil)
    }

   
    func testFetchRouteWithoutDestination() {
        viewModel.mapSelection = nil
        viewModel.fetchRoute(from: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertNil(viewModel.route)
    }

    func testFetchRouteWithDestination() {
        let expectation = self.expectation(description: "Route should be fetched successfully")
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
        viewModel.mapSelection = destination

        viewModel.$route
            .dropFirst()
            .sink { route in
                XCTAssertNotNil(route, "Route should not be nil.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchRoute(from: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))

        waitForExpectations(timeout: 5, handler: nil)
    }
}
