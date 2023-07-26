//
//  DetailViewControllerTests.swift
//  SearchyTests
//
//  Created by Yiğit Erdinç on 26.07.2023.
//

import XCTest
@testable import Searchy

class DetailViewControllerTests: XCTestCase {
  func testSetupView() {
    let viewModel = DetailViewModel(with: "tt0482571")
    let viewController = DetailViewController(viewModel: viewModel)
    
    viewController.viewDidLoad()
    
    XCTAssertTrue(viewController.view.subviews.contains(viewController.activityIndicatorView))
    XCTAssertTrue(viewController.view.subviews.contains(viewController.dimmerView))
    XCTAssertTrue(viewController.view.subviews.contains(viewController.contentView))
    
    XCTAssertTrue(viewController.contentView.subviews.contains(viewController.sliderPillView))
    XCTAssertTrue(viewController.contentView.subviews.contains(viewController.titleLabel))
    XCTAssertTrue(viewController.contentView.subviews.contains(viewController.genreLabel))
    XCTAssertTrue(viewController.contentView.subviews.contains(viewController.releaseDateLabel))
    XCTAssertTrue(viewController.contentView.subviews.contains(viewController.summaryLabel))
  }
  
  func testViewModelBindings() {
    let viewModel = DetailViewModel(with: "tt0482571")
    let viewController = DetailViewController(viewModel: viewModel)
    
    viewController.viewDidLoad()
    
    XCTAssertNotNil(viewController.viewModel.activityIndicatorStartAnimating)
    XCTAssertNotNil(viewController.viewModel.activityIndicatorStopAnimating)
    XCTAssertNotNil(viewController.viewModel.animateViewAppear)
    XCTAssertNotNil(viewController.viewModel.updateView)
    XCTAssertNotNil(viewController.viewModel.router.dismissViewController)
  }
}
