//
//  SearchViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

protocol CollectionViewCellTypable {
  var identifier: String { get }
  var cellClass: BaseCollectionViewCellProtocol.Type { get }
  var cellSize: CGSize { get }
}

protocol CollectionViewModelable {
  var reloadCollectionView: (() -> Void)? { get set }

  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func cellViewModelForItemAt(_ indexPath: IndexPath) -> BaseCellViewModelProtocol
}

protocol SearchViewModelProtocol: BaseViewModelProtocol, CollectionViewModelable {
  var router: SearchRouterProtocol { get set }
}

class SearchViewModel: SearchViewModelProtocol {
  var router: SearchRouterProtocol = SearchRouter()

  private var cellViewModels: [[BaseCellViewModelProtocol]] = []
  private var networkManager = SearchNetworkManager()

  var reloadCollectionView: (() -> Void)?

  func viewIsReady() {
    cellViewModels = [[GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel()],
                      [GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel()],
                      [GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel(),
                       GenericSearchResultCellViewModel()]]

    reloadCollectionView?()
  }
}

extension SearchViewModel {
  func numberOfSections() -> Int {
    return cellViewModels.count
  }

  func numberOfItemsInSection(_ section: Int) -> Int {
    return cellViewModels[section].count
  }

  func cellViewModelForItemAt(_ indexPath: IndexPath) -> BaseCellViewModelProtocol {
    return cellViewModels[indexPath.section][indexPath.row]
  }
}

extension SearchViewModel {
  enum CellTypes: CaseIterable, CollectionViewCellTypable {
    case genericSearchResult

    var identifier: String {
      return String(describing: cellClass)
    }

    var cellClass: BaseCollectionViewCellProtocol.Type {
      switch self {
      case .genericSearchResult: return GenericSearchResultCell.self
      }
    }

    var cellSize: CGSize {
      return CGSize(width: 0.0, height: 0.0)
    }
  }
}

class GenericSearchResultCell: UICollectionViewCell, BaseCollectionViewCellProtocol {
  var indexPath: IndexPath!
  var cellViewModel: BaseCellViewModelProtocol!

  func configureCell(with indexPath: IndexPath, and cellViewModel: BaseCellViewModelProtocol) {
    self.indexPath = indexPath
    self.cellViewModel = cellViewModel
  }
}

class GenericSearchResultCellViewModel: BaseCellViewModelProtocol {
  var type: CollectionViewCellTypable

  init() {
    type = SearchViewModel.CellTypes.genericSearchResult
  }
}
