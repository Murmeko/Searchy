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

    private var searchyImageViewWidthConstraint: NSLayoutConstraint?
    private var searchyImageViewHeightConstraint: NSLayoutConstraint?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.brandName
        label.font = .boldSystemFont(ofSize: 60)
        label.textColor = .systemIndigo
        return label
    }()

    private var titleLabelWidthConstraint: NSLayoutConstraint?

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
        searchyImageViewWidthConstraint = searchyImageView.widthAnchor.constraint(equalToConstant: 46)
        searchyImageViewHeightConstraint = searchyImageView.heightAnchor.constraint(equalToConstant: 46)
        searchyImageViewWidthConstraint?.isActive = true
        searchyImageViewHeightConstraint?.isActive = true
    }

    private func addTitleLabel() {
        addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension GeneralBrandView {
    func animateAppear() -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.25) {
                self.searchyImageView.isHidden = false
                self.titleLabel.isHidden = false
                self.searchyImageView.alpha = 1.0
                self.titleLabel.alpha = 1.0
            }
        }
    }

    func animateDisappear() -> (_ completion: @escaping (() -> Void)) -> Void {
        return { [weak self] completion in
            guard let self = self else { return }
            self.hideTitleLabel {
                self.enlargeSearchyImageView {
                    completion()
                }
            }
        }
    }

    private func hideTitleLabel(completion: @escaping (() -> Void)) {
        titleLabelWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.frame.width)
        titleLabelWidthConstraint?.isActive = true

        UIView.animate(withDuration: 0.5, animations: {
            self.titleLabelWidthConstraint?.constant = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.titleLabelWidthConstraint?.isActive = false
            self.titleLabel.alpha = 0.0
            self.titleLabel.isHidden = true
            completion()
        })
    }

    private func enlargeSearchyImageView(completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.25, animations: {
            self.searchyImageViewWidthConstraint?.constant = 750
            self.searchyImageViewHeightConstraint?.constant = 750
            self.searchyImageView.alpha = 0.0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.searchyImageViewWidthConstraint?.constant = 46
            self.searchyImageViewHeightConstraint?.constant = 46
            self.searchyImageView.isHidden = true
            completion()
        })
    }
}
