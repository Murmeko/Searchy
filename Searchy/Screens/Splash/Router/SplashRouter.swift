//
//  SplashRouter.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import Foundation

protocol SplashRouterProtocol: BaseRouterProtocol {
  func presentSearchViewController()
}

class SplashRouter: BaseRouter, SplashRouterProtocol {
  func presentSearchViewController() {
    let searchViewController = SearchViewController()
    searchViewController.modalPresentationStyle = .overFullScreen
    presentViewController?(searchViewController)
  }
}
