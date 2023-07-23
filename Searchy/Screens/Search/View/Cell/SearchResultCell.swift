//
//  SearchResultCell.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit
import NukeExtensions

class SearchResultCell: BaseCollectionViewCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!

  override func configureCell(with indexPath: IndexPath, and cellViewModel: BaseCellViewModelProtocol) {
    super.configureCell(with: indexPath, and: cellViewModel)

    guard let cellViewModel = cellViewModel as? SearchResultCellViewModelProtocol else { return }
    containerView.backgroundColor = .secondarySystemBackground

    containerView.layer.cornerRadius = 25
    posterImageView.layer.cornerRadius = 16

    loadImage(with: cellViewModel.posterImageURL, into: posterImageView)
    titleLabel.text = cellViewModel.titleLabelText
  }
}
