//
//  SearchViewControllerTests.swift
//  SearchyTests
//
//  Created by Yiğit Erdinç on 26.07.2023.
//

import XCTest
@testable import Searchy

class SearchViewControllerTests: XCTestCase {
    func testSetupView() {
        let viewController = SearchViewController()

        viewController.viewDidLoad()

        XCTAssertTrue(viewController.navigationItem.titleView == viewController.brandedTitleView)
        XCTAssertTrue(viewController.navigationItem.searchController == viewController.searchController)

        XCTAssertNotNil(viewController.collectionView)
    }

    func testViewModelBindings() {
        let viewController = SearchViewController()

        viewController.viewDidLoad()

        XCTAssertNotNil(viewController.viewModel.reloadCollectionView)
        XCTAssertNotNil(viewController.viewModel.router.presentViewController)
        XCTAssertNotNil(viewController.viewModel.router.dismissViewController)
    }
}
