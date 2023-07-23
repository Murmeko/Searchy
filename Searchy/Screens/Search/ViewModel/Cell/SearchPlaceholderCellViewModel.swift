//
//  SearchPlaceholderCellViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit

protocol SearchPlaceholderCellViewModelProtocol: BaseCellViewModelProtocol {}

class SearchPlaceholderCellViewModel: SearchPlaceholderCellViewModelProtocol {
  var type: CollectionViewCellTypable

  init() {
    self.type = SearchViewModel.CellTypes.searchPlaceholder
  }

  func getSize() -> CGSize {
    let cellWidth = (UIScreen.main.bounds.width - 30) / 2
    let posterPlaceholderHeight = (cellWidth - 32) * 1.6
    let titlePlaceholderHeight: CGFloat = 18
    return CGSize(width: cellWidth, height: (16.0 + posterPlaceholderHeight + 12.0 + titlePlaceholderHeight + 16.0))
  }
}
