//
//  SearchEmptyCell.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit

class SearchEmptyCell: BaseCollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emptyLabelContainerView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!

    override func configureCell(with indexPath: IndexPath, and cellViewModel: BaseCellViewModelProtocol) {
        super.configureCell(with: indexPath, and: cellViewModel)

        guard let cellViewModel = cellViewModel as? SearchEmptyCellViewModelProtocol else { fatalError() }

        containerView.layer.cornerRadius = 34
        emptyLabelContainerView.layer.cornerRadius = 22

        emptyLabel.text = cellViewModel.emptyLabelText
    }
}
