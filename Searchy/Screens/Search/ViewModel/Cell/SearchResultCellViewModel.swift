//
//  SearchResultCellViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit

protocol SearchResultCellViewModelProtocol: BaseCellViewModelProtocol {
  var posterImageURL: URL? { get }
  var titleLabelText: String? { get }
}

class SearchResultCellViewModel: SearchResultCellViewModelProtocol {
  var posterImageURL: URL?
  var titleLabelText: String?

  var type: CollectionViewCellTypable

  init(posterImagePath: String? = nil, titleLabelText: String? = nil) {
    if let posterImagePath { self.posterImageURL = URL(string: posterImagePath) }
    self.titleLabelText = titleLabelText
    self.type = SearchViewModel.CellTypes.searchResult
  }

  func getSize() -> CGSize {
    let cellWidth = (UIScreen.main.bounds.width - 30) / 2
    let posterImageHeight = (cellWidth - 32) * 1.6
    let titleLabelHeight = titleLabelText!.height(withConstrainedWidth: cellWidth - 32, font: UIFont.systemFont(ofSize: 18))
    return CGSize(width: cellWidth, height: (16.0 + posterImageHeight + 12.0 + titleLabelHeight + 16.0))
  }
}
