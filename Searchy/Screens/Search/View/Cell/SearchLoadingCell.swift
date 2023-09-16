//
//  SearchLoadingCell.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 23.07.2023.
//

import UIKit

class SearchLoadingCell: BaseCollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicatorContainerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func configureCell(with indexPath: IndexPath, and cellViewModel: BaseCellViewModelProtocol) {
        super.configureCell(with: indexPath, and: cellViewModel)
        guard cellViewModel is SearchLoadingCellViewModelProtocol else { fatalError() }

        containerView.layer.cornerRadius = 34
        activityIndicatorContainerView.layer.cornerRadius = 22

        activityIndicatorView.startAnimating()
    }
}
