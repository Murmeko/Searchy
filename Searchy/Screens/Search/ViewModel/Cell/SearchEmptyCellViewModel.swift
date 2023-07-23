//
//  SearchEmptyCellViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit

protocol SearchEmptyCellViewModelProtocol: BaseCellViewModelProtocol {
  var emptyLabelText: String? { get }
}

class SearchEmptyCellViewModel: SearchEmptyCellViewModelProtocol {
  var emptyLabelText: String?

  var type: CollectionViewCellTypable

  init(text: String?) {
    self.emptyLabelText = text
    self.type = SearchViewModel.CellTypes.searchEmpty
  }

  func getSize() -> CGSize {
    let cellWidth: CGFloat = (UIScreen.main.bounds.width - 30)
    let cellHeight: CGFloat = 68.0
    return CGSize(width: cellWidth, height: cellHeight)
  }
}
