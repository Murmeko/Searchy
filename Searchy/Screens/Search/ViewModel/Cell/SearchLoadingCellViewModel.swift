//
//  SearchLoadingCellViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 23.07.2023.
//

import UIKit

protocol SearchLoadingCellViewModelProtocol: BaseCellViewModelProtocol {}

class SearchLoadingCellViewModel: SearchLoadingCellViewModelProtocol {
  var type: CollectionViewCellTypable

  init() {
    self.type = SearchViewModel.CellTypes.searchLoading
  }

  func getSize() -> CGSize {
    let cellWidth: CGFloat = (UIScreen.main.bounds.width - 30)
    let cellHeight: CGFloat = 68.0
    return CGSize(width: cellWidth, height: cellHeight)
  }
}
