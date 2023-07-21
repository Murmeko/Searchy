//
//  SearchViewController.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 20.07.2023.
//

import UIKit

protocol SearchViewControllerProtocol: BaseViewControllerProtocol {
  var viewModel: SearchViewModelProtocol { get }
}

class SearchViewController: UIViewController, SearchViewControllerProtocol {
  var searchBar: UISearchBar!
  var collectionView: UICollectionView!

  var viewModel: SearchViewModelProtocol = SearchViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    bindViewModel()
    viewModel.viewIsReady()
  }
}

// MARK: ViewController Setup
extension SearchViewController {
  internal func setupView() {
    view.backgroundColor = .systemBackground
    setupSearchBar()
    setupCollectionView()
  }
}

extension SearchViewController: UISearchBarDelegate {
  private func setupSearchBar() {
    searchBar = UISearchBar()
    searchBar.searchBarStyle = UISearchBar.Style.default
    searchBar.placeholder = " Search..."
    searchBar.sizeToFit()
    searchBar.isTranslucent = false
    searchBar.backgroundImage = UIImage()
    searchBar.delegate = self

    navigationItem.titleView = searchBar
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  private func setupCollectionView() {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let cellWidth = (UIScreen.main.bounds.width - 30) / 2
    let cellHeight = cellWidth * 2
    layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    registerCells()

    collectionView.dataSource = self
    collectionView.delegate = self

    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }

  private final func registerCells() {
    SearchViewModel.CellTypes.allCases.forEach { (cellType) in
      collectionView.register(cellType.cellClass, forCellWithReuseIdentifier: cellType.identifier)
    }
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItemsInSection(section)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellViewModel = viewModel.cellViewModelForItemAt(indexPath)

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.type.identifier,
                                                        for: indexPath) as? BaseCollectionViewCellProtocol else { fatalError() }
    cell.configureCell(with: indexPath, and: cellViewModel)
    cell.backgroundColor = .systemIndigo
    return cell
  }
}

// MARK: - ViewModel Bindings
extension SearchViewController {
  internal func bindViewModel() {
    viewModel.router.pushViewController = pushViewController()
    viewModel.router.dismissViewController = dismissViewController()
    viewModel.reloadCollectionView = reloadCollectionView()
  }

  private func reloadCollectionView() -> () -> Void {
    return { [weak self] in
      guard let self = self else { return }
      self.collectionView.reloadData()
    }
  }
}
