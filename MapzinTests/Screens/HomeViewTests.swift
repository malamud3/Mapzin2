import XCTest
import MapKit
@testable import Mapzin

class HomeViewTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.results.isEmpty)
        XCTAssertNil(viewModel.mapSelection)
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.route)
        XCTAssertFalse(viewModel.routeDisplaying)
        XCTAssertNil(viewModel.routeDestination)
    }
    
    func testSearch() {
        let expectation = XCTestExpectation(description: "Search completed")
        
        viewModel.searchText = "Test Location"
        
        // Simulate search completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(viewModel.isSearching)
        // Add more assertions based on expected search behavior
    }
    
    func testMapSelection() {
        let mockItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)))
        viewModel.mapSelection = mockItem
        
        XCTAssertNotNil(viewModel.mapSelection)
        XCTAssertEqual(viewModel.mapSelection, mockItem)
    }
    
    func testRouteCalculation() {
        let expectation = XCTestExpectation(description: "Route calculated")
        
        let mockDestination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1)))
        viewModel.mapSelection = mockDestination
        
        viewModel.fetchRoute(from: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        // Simulate route calculation completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(viewModel.route)
        XCTAssertTrue(viewModel.routeDisplaying)
        XCTAssertEqual(viewModel.routeDestination, mockDestination)
    }
    
    // Add more tests as needed
}
