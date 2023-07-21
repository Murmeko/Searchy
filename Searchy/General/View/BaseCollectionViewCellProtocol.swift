//
//  BaseCollectionViewCellProtocol.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit

protocol BaseCollectionViewCellProtocol: UICollectionViewCell {
  var indexPath: IndexPath! { get }
  var cellViewModel: BaseCellViewModelProtocol! { get }

  func configureCell(with indexPath: IndexPath, and cellViewModel: BaseCellViewModelProtocol)
}
