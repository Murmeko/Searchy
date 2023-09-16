//
//  BrandedTitleView.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit

class BrandedTitleView: UIStackView {
    lazy var searchyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.brandLogo
        imageView.tintColor = .systemIndigo
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.brandName
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemIndigo
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupView()
        addSearchyImageView()
        addTitleLabel()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BrandedTitleView {
    private func setupView() {
        axis = .horizontal
        alignment = .center
        distribution = .fill
        spacing = 4
    }

    private func addSearchyImageView() {
        addArrangedSubview(searchyImageView)
        searchyImageView.translatesAutoresizingMaskIntoConstraints = false
        searchyImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        searchyImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    private func addTitleLabel() {
        addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
