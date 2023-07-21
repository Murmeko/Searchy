//
//  SearchViewController.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 20.07.2023.
//

import UIKit

protocol SearchViewControllerProtocol: BaseViewControllerProtocol {
  var viewModel: SearchViewModelProtocol { get }
}

class SearchViewController: UIViewController, SearchViewControllerProtocol {
  var viewModel: SearchViewModelProtocol = SearchViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    bindViewModel()
  }
}

// MARK: ViewController Setup
extension SearchViewController {
  internal func setupView() {
    view.backgroundColor = .black
  }
}

// MARK: - ViewModel Bindings
extension SearchViewController {
  internal func bindViewModel() {
    viewModel.router.pushViewController = pushViewController()
    viewModel.router.dismissViewController = dismissViewController()
  }
}
