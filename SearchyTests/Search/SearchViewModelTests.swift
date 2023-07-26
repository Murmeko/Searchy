//
//  SearchViewModelTests.swift
//  SearchyTests
//
//  Created by Yiğit Erdinç on 26.07.2023.
//

import XCTest
@testable import Searchy

class SearchViewModelTests: XCTestCase {
  func testCollectionViewDataSourceMethods() {
    let viewModel = SearchViewModel()
    
    viewModel.cellViewModels = [[SearchLoadingCellViewModel()],
                                [SearchEmptyCellViewModel(text: "Test Empty Cell")],
                                [SearchLoadingCellViewModel()]]
    
    let section = 2
    let indexPath = IndexPath(row: 0, section: section)
    
    let expectedNumberOfSections = 3
    XCTAssertEqual(viewModel.numberOfSections(), expectedNumberOfSections)
    
    let expectedNumberOfItemsInSection = 1
    XCTAssertEqual(viewModel.numberOfItemsInSection(section), expectedNumberOfItemsInSection)
    
    XCTAssertNotNil(viewModel.cellViewModelForItemAt(indexPath))
  }
}
