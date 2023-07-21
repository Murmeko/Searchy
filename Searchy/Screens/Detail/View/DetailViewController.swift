//
//  DetailViewController.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

protocol DetailViewControllerProtocol: BaseViewControllerProtocol {
  var viewModel: DetailViewModelProtocol { get }
}

class DetailViewController: UIViewController, DetailViewControllerProtocol {
  var viewModel: DetailViewModelProtocol = DetailViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    bindViewModel()
  }
}

// MARK: ViewController Setup
extension DetailViewController {
  internal func setupView() {
  }
}

// MARK: - ViewModel Bindings
extension DetailViewController {
  internal func bindViewModel() {
    viewModel.router.pushViewController = pushViewController()
    viewModel.router.dismissViewController = dismissViewController()
  }
}
