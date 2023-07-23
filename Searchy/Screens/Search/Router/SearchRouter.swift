//
//  SearchRouter.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import Foundation

protocol SearchRouterProtocol: BaseRouterProtocol {
  func pushDetailViewController(imdbID: String)
}

class SearchRouter: BaseRouter, SearchRouterProtocol {
  func pushDetailViewController(imdbID: String) {
    let detailViewModel = DetailViewModel(with: imdbID)
    let detailViewController = DetailViewController(viewModel: detailViewModel)
    detailViewController.modalPresentationStyle = .overFullScreen
    presentViewController?(detailViewController)
  }
}
