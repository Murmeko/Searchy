//
//  SearchViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

protocol SearchViewModelProtocol: BaseViewModelProtocol, CollectionViewModelable {
  var router: SearchRouterProtocol { get set }

  func fetchResults(for searchText: String?)
  func fetchNextPage()
}

class SearchViewModel: SearchViewModelProtocol {
  var router: SearchRouterProtocol = SearchRouter()

  var cellViewModels: [[BaseCellViewModelProtocol]] = []

  private var networkManager = SearchNetworkManager()

  private var pageNumber: Int = 1
  private var totalResults: Int?

  private var isFetching: Bool = false
  private var fetchedInitialResults: Bool = false

  private var searchedText: String?

  var reloadCollectionView: (() -> Void)?

  func viewIsReady() {
    setInitialEmptyCell()
  }
}

// MARK: ViewModel Networking
extension SearchViewModel {
  func fetchResults(for searchText: String?) {
    guard !isFetching, let searchText = searchText else { return }
    fetchedInitialResults = false
    isFetching = true
    searchedText = nil
    pageNumber = 0

    setLoadingCell()

    networkManager.getSearchResults(for: searchText) { [weak self] searchModel in
      guard let self = self else { return }
      self.cellViewModels = []
      self.reloadCollectionView?()
      if let totalResults = searchModel?.totalResults, let searchResultModels = searchModel?.search, !searchResultModels.isEmpty {
        self.totalResults = Int(totalResults)

        self.cellViewModels.append(getSearchResultCellViewModels(for: searchResultModels))
        self.reloadCollectionView?()

        self.searchedText = searchText
        self.pageNumber = 1
      } else {
        self.setNoResultFoundCell()
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
        if let searchResultModels = searchModel?.search, !searchResultModels.isEmpty {
          self.cellViewModels[self.cellViewModels.count - 1].removeLast()
          self.cellViewModels.append(getSearchResultCellViewModels(for: searchResultModels))
          self.reloadCollectionView?()
        }

        self.isFetching = false
        self.pageNumber += 1
      }
    } else {
      insertNoMoreResultsFoundCell()
    }
  }
}

// MARK: ViewModel Cell Parsers
extension SearchViewModel {
  private func setInitialEmptyCell() {
    cellViewModels = [[SearchEmptyCellViewModel(text: "Enter a text to search")]]
    reloadCollectionView?()
  }

  private func setLoadingCell() {
    cellViewModels = [[SearchLoadingCellViewModel()]]
    reloadCollectionView?()
  }

  private func getSearchResultCellViewModels(for searchResultModels: [SearchResultModel]) -> [BaseCellViewModelProtocol] {
    var cellViewModels: [BaseCellViewModelProtocol] = []
    searchResultModels.forEach({ searchResultModel in
      cellViewModels.append(SearchResultCellViewModel(model: searchResultModel))
    })

    cellViewModels.append(SearchLoadingCellViewModel())

    return cellViewModels
  }

  private func setNoResultFoundCell() {
    cellViewModels = [[SearchEmptyCellViewModel(text: "No result found")]]
    reloadCollectionView?()
  }

  private func insertNoMoreResultsFoundCell() {
    cellViewModels[cellViewModels.count - 1].removeLast()
    cellViewModels.append([SearchEmptyCellViewModel(text: "No more result found")])
    reloadCollectionView?()
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

// MARK: CollectionViewCell Cell Registration
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
