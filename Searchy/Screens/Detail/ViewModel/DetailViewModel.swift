//
//  DetailViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import Foundation

protocol DetailViewModelProtocol: BaseViewModelProtocol {
  var router: DetailRouterProtocol { get set }
}

class DetailViewModel: DetailViewModelProtocol {
  var router: DetailRouterProtocol = DetailRouter()

  func viewIsReady() {
  }
}
