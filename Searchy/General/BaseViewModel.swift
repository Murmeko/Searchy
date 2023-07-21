//
//  BaseViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

protocol BaseViewModelProtocol {
  func viewIsReady()
}

class BaseViewModel: BaseViewModelProtocol {
  func viewIsReady() {
    // To be overridden.
  }
}
