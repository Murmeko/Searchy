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
}

protocol CollectionViewModelable {
  var reloadCollectionView: (() -> Void)? { get set }

  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func cellViewModelForItemAt(_ indexPath: IndexPath) -> BaseCellViewModelProtocol
  func sizeForItemAt(_ indexPath: IndexPath) -> CGSize
  func willDisplay(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
  func didSelectItemAt(_ indexPath: IndexPath)
}

protocol SearchViewModelProtocol: BaseViewModelProtocol, CollectionViewModelable {
  var router: SearchRouterProtocol { get set }

  func fetchResults(for searchText: String?)
  func fetchNextPage()
}

class SearchViewModel: SearchViewModelProtocol {
  var router: SearchRouterProtocol = SearchRouter()

  private var cellViewModels: [[BaseCellViewModelProtocol]] = []
  private var networkManager = SearchNetworkManager()

  private var pageNumber: Int = 1
  private var totalResults: Int?

  private var isFetching: Bool = false
  private var fetchedInitialResults: Bool = false

  private var searchedText: String?

  var reloadCollectionView: (() -> Void)?

  func viewIsReady() {
    cellViewModels = [[SearchEmptyCellViewModel(text: "Enter a text to search")]]
    reloadCollectionView?()
  }
}

// MARK: Networking
extension SearchViewModel {
  func fetchResults(for searchText: String?) {
    guard !isFetching, let searchText = searchText else { return }
    fetchedInitialResults = false
    isFetching = true
    searchedText = nil
    pageNumber = 0

    cellViewModels = [[SearchLoadingCellViewModel()]]
    reloadCollectionView?()

    networkManager.getSearchResults(for: searchText) { [weak self] searchModel in
      guard let self = self else { return }
      self.cellViewModels = []
      self.reloadCollectionView?()
      if let searchModel = searchModel,
         let searchResultModels = searchModel.search,
         !searchResultModels.isEmpty {
        self.totalResults = Int(searchModel.totalResults ?? "0")
        var mutableCellViewModels: [BaseCellViewModelProtocol] = []
        searchResultModels.forEach({ searchResultModel in
          mutableCellViewModels.append(SearchResultCellViewModel(model: searchResultModel))
        })
        mutableCellViewModels.append(SearchLoadingCellViewModel())
        self.cellViewModels.append(mutableCellViewModels)
        self.reloadCollectionView?()

        self.searchedText = searchText
        self.pageNumber = 1
      } else {
        cellViewModels = [[SearchEmptyCellViewModel(text: "No result found :(")]]
        reloadCollectionView?()
      }

      self.fetchedInitialResults = true
      self.isFetching = false
    }
  }

  func fetchNextPage() {
    guard fetchedInitialResults, !isFetching, let totalResults = totalResults, let searchedText = searchedText else { return }
    if pageNumber < totalResults / 15 {
      isFetching = true
      networkManager.getSearchResults(for: searchedText, pageNumber: pageNumber + 1) { [weak self] searchModel in
        guard let self = self else { return }
        if let searchModel = searchModel,
           let searchResultModels = searchModel.search,
           !searchResultModels.isEmpty {
          var mutableCellViewModels: [BaseCellViewModelProtocol] = []
          searchResultModels.forEach({ searchResultModel in
            mutableCellViewModels.append(SearchResultCellViewModel(model: searchResultModel))
          })
          self.cellViewModels[self.cellViewModels.count - 1].removeLast()
          mutableCellViewModels.append(SearchLoadingCellViewModel())
          self.cellViewModels.append(mutableCellViewModels)
          self.reloadCollectionView?()
        }

        self.isFetching = false
        self.pageNumber += 1
      }
    } else {
      cellViewModels[cellViewModels.count - 1].removeLast()
      cellViewModels.append([SearchEmptyCellViewModel(text: "No more results")])
      reloadCollectionView?()
    }
  }
}

// MARK: - CollectionView Getters
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

  func sizeForItemAt(_ indexPath: IndexPath) -> CGSize {
    return cellViewModels[indexPath.section][indexPath.row].getSize()
  }

  func willDisplay(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if cell is SearchLoadingCell { fetchNextPage() }
  }

  func didSelectItemAt(_ indexPath: IndexPath) {
    guard let cellViewModel = cellViewModels[indexPath.section][indexPath.row] as? SearchResultCellViewModelProtocol,
          let imdbID = cellViewModel.imdbID else { return }
    router.pushDetailViewController(imdbID: imdbID)
  }
}

// MARK: CollectionViewCell register
extension SearchViewModel {
  enum CellTypes: CaseIterable, CollectionViewCellTypable {
    case searchResult
    case searchLoading
    case searchEmpty

    var identifier: String {
      return String(describing: cellClass)
    }

    var cellClass: BaseCollectionViewCellProtocol.Type {
      switch self {
      case .searchResult: return SearchResultCell.self
      case .searchLoading: return SearchLoadingCell.self
      case .searchEmpty: return SearchEmptyCell.self
      }
    }
  }
}
