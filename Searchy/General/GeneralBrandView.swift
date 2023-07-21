//
//  GeneralBrandView.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

class GeneralBrandView: UIStackView {
  lazy var searchyImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Constants.brandLogo
    imageView.tintColor = .systemIndigo
    return imageView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = Constants.brandName
    label.font = .boldSystemFont(ofSize: 60)
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

extension GeneralBrandView {
  private func setupView() {
    axis = .horizontal
    alignment = .center
    distribution = .fill
    spacing = 12
  }

  private func addSearchyImageView() {
    addArrangedSubview(searchyImageView)
    searchyImageView.translatesAutoresizingMaskIntoConstraints = false
    searchyImageView.widthAnchor.constraint(equalToConstant: 46).isActive = true
    searchyImageView.heightAnchor.constraint(equalToConstant: 46).isActive = true
  }

  private func addTitleLabel() {
    addArrangedSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
  }
}
