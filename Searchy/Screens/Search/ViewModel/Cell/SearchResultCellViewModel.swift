//
//  SearchResultCellViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit

protocol SearchResultCellViewModelProtocol: BaseCellViewModelProtocol {
  var imdbID: String? { get }
  var posterImageURL: URL? { get }
  var titleLabelText: String? { get }
}

class SearchResultCellViewModel: SearchResultCellViewModelProtocol {
  var imdbID: String?
  var posterImageURL: URL?
  var titleLabelText: String?

  var type: CollectionViewCellTypable

  init(model: SearchResultModel) {
    imdbID = model.imdbId
    if let posterImagePath = model.poster { posterImageURL = URL(string: posterImagePath) }
    titleLabelText = model.title
    type = SearchViewModel.CellTypes.searchResult
  }

  func getSize() -> CGSize {
    let cellWidth = (UIScreen.main.bounds.width - 30) / 2
    let posterImageHeight = (cellWidth - 32) * 1.6
    let titleLabelHeight = titleLabelText!.height(withConstrainedWidth: cellWidth - 32, font: UIFont.systemFont(ofSize: 18))
    return CGSize(width: cellWidth, height: (16.0 + posterImageHeight + 12.0 + titleLabelHeight + 16.0))
  }
}
