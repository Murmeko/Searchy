//
//  SplashViewController.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 20.07.2023.
//

import UIKit

protocol SplashViewControllerProtocol: BaseViewControllerProtocol {
  var viewModel: SplashViewModelProtocol { get }
}

class SplashViewController: UIViewController, SplashViewControllerProtocol {
  private lazy var generalBrandView = GeneralBrandView()
  private lazy var developerLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 24)
    label.alpha = 0.0
    return label
  }()

  var viewModel: SplashViewModelProtocol = SplashViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    bindViewModel()

    viewModel.viewIsReady()
  }
}

// MARK: ViewController Setup
extension SplashViewController {
  internal func setupView() {
    view.backgroundColor = .systemBackground
    setupGeneralBrandView()
    setupDeveloperLabel()
  }

  private func setupGeneralBrandView() {
    view.addSubview(generalBrandView)
    generalBrandView.translatesAutoresizingMaskIntoConstraints = false
    generalBrandView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    generalBrandView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  private func setupDeveloperLabel() {
    view.addSubview(developerLabel)
    developerLabel.translatesAutoresizingMaskIntoConstraints = false
    developerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    developerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
  }
}

// MARK: - ViewModel Bindings
extension SplashViewController {
  internal func bindViewModel() {
    viewModel.router.presentViewController = presentViewController()
    viewModel.updateView = updateView()
    viewModel.updateDeveloperLabel = updateDeveloperLabel()
  }

  private func updateView() -> () -> Void {
    return { [weak self] in
      guard let self = self else { return }
      self.developerLabel.text = self.viewModel.developerLabelText

      UIView.animate(withDuration: 0.5) {
        self.view.backgroundColor = self.viewModel.backgroundColor
        self.developerLabel.alpha = 1.0
      }
    }
  }

  private func updateDeveloperLabel() -> () -> Void {
    return { [weak self] in
      guard let self = self else { return }
      UIView.animate(withDuration: 0.75, animations: {
        self.developerLabel.alpha = 0.0
      }, completion: { _ in
        self.developerLabel.text = self.viewModel.developerLabelText
        UIView.animate(withDuration: 0.55, animations: {
          self.developerLabel.alpha = 1.0
        })
      })
    }
  }
}
