//
//  SearchViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import Foundation

protocol SearchViewModelProtocol: BaseViewModelProtocol {
  var router: SearchRouterProtocol { get set }
}

class SearchViewModel: SearchViewModelProtocol {
  var router: SearchRouterProtocol = SearchRouter()

  func viewIsReady() {
  }
}
