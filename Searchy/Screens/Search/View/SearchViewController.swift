//
//  SearchViewController.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 20.07.2023.
//

import UIKit

class SearchViewController: UIViewController, BaseViewControllerProtocol {
  lazy var brandedTitleView = BrandedTitleView()
  let searchController = UISearchController()
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

    navigationItem.titleView = brandedTitleView
    navigationItem.searchController = searchController

    setupSearchBar()
    setupCollectionView()
  }
}

// MARK: - SearchBar Setup
extension SearchViewController: UISearchBarDelegate {
  private func setupSearchBar() {
    searchController.searchBar.delegate = self
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.fetchResults(for: searchBar.text)
    searchController.isActive = false
  }
}

// MARK: - CollectionView Setup
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  private func setupCollectionView() {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

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
      collectionView.register(UINib(nibName: cellType.identifier, bundle: nil), forCellWithReuseIdentifier: cellType.identifier)
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
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.type.identifier, for: indexPath) as? BaseCollectionViewCellProtocol else { fatalError() }
    cell.configureCell(with: indexPath, and: cellViewModel)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return viewModel.sizeForItemAt(indexPath)
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    viewModel.willDisplay(cell, forItemAt: indexPath)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItemAt(indexPath)
  }
}

// MARK: - ViewModel Bindings
extension SearchViewController {
  internal func bindViewModel() {
    viewModel.router.presentViewController = presentViewController()
    viewModel.router.dismissViewController = dismissViewController()
    viewModel.reloadCollectionView = reloadCollectionView()
  }

  private func reloadCollectionView() -> () -> Void {
    return { [weak self] in
      guard let self = self else { return }
      self.collectionView.reloadData()
    }
  }

  private func presentViewController() -> (UIViewController) -> Void {
    return { [weak self] viewController in
      guard let self = self else { return }
      self.present(viewController, animated: false)
    }
  }
}
