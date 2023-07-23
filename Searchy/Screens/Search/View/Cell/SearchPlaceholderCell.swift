//
//  SearchPlaceholderCell.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit

class SearchPlaceholderCell: BaseCollectionViewCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var posterPlaceholderView: UIView!
  @IBOutlet weak var titlePlaceholderView: UIView!

  override func configureCell(with indexPath: IndexPath, and cellViewModel: BaseCellViewModelProtocol) {
    super.configureCell(with: indexPath, and: cellViewModel)

    containerView.layer.cornerRadius = 25
    posterPlaceholderView.layer.cornerRadius = 20
    titlePlaceholderView.layer.cornerRadius = 9

    posterPlaceholderView.startShimmering()
    titlePlaceholderView.startShimmering()
  }
}
