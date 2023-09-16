//
//  CollectionViewModelable.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 23.07.2023.
//

import UIKit

protocol CollectionViewModelable {
    var reloadCollectionView: (() -> Void)? { get set }

    func numberOfSections() -> Int
    func numberOfItemsInSection(_ section: Int) -> Int
    func cellViewModelForItemAt(_ indexPath: IndexPath) -> BaseCellViewModelProtocol
    func sizeForItemAt(_ indexPath: IndexPath) -> CGSize
    func willDisplay(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func didSelectItemAt(_ indexPath: IndexPath)
}
