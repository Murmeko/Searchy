//
//  BaseViewController.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

protocol BaseViewControllerProtocol: UIViewController {
  func setupView()
  func bindViewModel()
}

extension BaseViewControllerProtocol {
  func presentViewController() -> (UIViewController) -> Void {
    return { [weak self] viewController in
      guard let self = self else { return }
      self.present(viewController, animated: true)
    }
  }

  func pushViewController() -> (UIViewController) -> Void {
    return { [weak self] viewController in
      guard let self = self else { return }
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  }

  func dismissViewController() -> () -> Void {
    return { [weak self] in
      guard let self = self else { return }
      self.dismiss(animated: true)
    }
  }
}
