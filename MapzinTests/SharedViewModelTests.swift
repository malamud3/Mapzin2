//
//  AccordionListViewTests.swift
//  MapzinTests
//
//  Created by Amir Malamud on 28/07/2024.
//

import XCTest
@testable import Mapzin

final class SharedViewModelTests: XCTestCase {
    
    var viewModel: SharedViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SharedViewModel()
    }

    func testInitialState() {
        XCTAssertNil(viewModel.selectedItem)
        XCTAssertFalse(viewModel.showAccordionList)
    }

    func testItemSelection() {
        // Given
        let selectedItem = "Room 101"
        
        // When
        viewModel.selectedItem = selectedItem
        
        // Then
        XCTAssertEqual(viewModel.selectedItem, selectedItem)
    }
    
    func testToggleShowAccordionList() {
        // Initially false
        XCTAssertFalse(viewModel.showAccordionList)
        
        // When
        viewModel.showAccordionList = true
        
        // Then
        XCTAssertTrue(viewModel.showAccordionList)
    }
}
