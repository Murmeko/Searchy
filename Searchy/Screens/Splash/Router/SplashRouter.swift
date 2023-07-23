//
//  SplashRouter.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

protocol SplashRouterProtocol: BaseRouterProtocol {
  func presentSearchViewController()
}

class SplashRouter: BaseRouter, SplashRouterProtocol {
  func presentSearchViewController() {
    let searchViewController = SearchViewController()
    UIApplication.shared.firstWindow()?.rootViewController = UINavigationController(rootViewController: searchViewController)
    UIApplication.shared.firstWindow()?.makeKeyAndVisible()
  }
}
