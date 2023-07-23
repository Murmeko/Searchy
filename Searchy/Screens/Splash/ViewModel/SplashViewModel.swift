//
//  SplashViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 20.07.2023.
//

import UIKit
import FirebaseRemoteConfig

protocol SplashViewModelProtocol: BaseViewModelProtocol {
  var router: SplashRouterProtocol { get set }

  var backgroundColor: UIColor? { get }
  var developerLabelText: String? { get }

  var updateView: (() -> Void)? { get set }
  var updateDeveloperLabel: ((_ completion: @escaping (() -> Void)) -> Void)? { get set }

  var hideGeneralBrandView: ((_ completion: @escaping (() -> Void)) -> Void)? { get set }
}

class SplashViewModel: SplashViewModelProtocol {
  var router: SplashRouterProtocol = SplashRouter()

  var backgroundColor: UIColor?
  var developerLabelText: String?

  var updateView: (() -> Void)?
  var updateDeveloperLabel: ((_ completion: @escaping (() -> Void)) -> Void)?

  var hideGeneralBrandView: ((_ completion: @escaping (() -> Void)) -> Void)?

  private var remoteConfig: RemoteConfig!

  init() {
    setupRemoteConfig()
  }

  func viewIsReady() {
    if NetworkReachability.shared.isReachable {
      backgroundColor = .systemBackground
      developerLabelText = "Yiğit Erdinç"
    } else {
      backgroundColor = .red
      developerLabelText = "No internet connection 😔"
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.updateView?()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        guard let self = self else { return }
        self.requestRemoteConfig()
      }
    }
  }
}

// MARK: - ViewModel RemoteConfig operations
extension SplashViewModel {
  private func setupRemoteConfig() {
    remoteConfig = RemoteConfig.remoteConfig()

    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0

    remoteConfig.configSettings = settings
    remoteConfig.setDefaults(fromPlist: Constants.remoteConfigDefaults)
  }

  private func requestRemoteConfig() {
    remoteConfig.fetchAndActivate { [weak self] status, error in
      guard let self = self else { return }
      if let error { self.handleRemoteConfigFailure(error); return }
      self.handleRemoteConfigResult(status)
    }
  }

  private func handleRemoteConfigResult(_ status: RemoteConfigFetchAndActivateStatus) {
    switch status {
    case .successFetchedFromRemote: handleRemoteConfigSuccess()
    case .successUsingPreFetchedData: fatalError()
    default: handleRemoteConfigFailure()
    }
  }

  private func handleRemoteConfigSuccess() {
    developerLabelText = remoteConfig[Constants.Splash.openingTitle].stringValue
    updateDeveloperLabel? { [weak self] in
      guard let self = self else { return }
      self.hideGeneralBrandView? {
        self.router.presentSearchViewController()
      }
    }
  }

  private func handleRemoteConfigFailure(_ error: Error? = nil) {
    if let error {
      print("Error occured while fetching Firebase Remote Config")
      print(error)
    } else {
      print("Unknown error occured while fetching Firebase Remote Config.")
    }
  }
}
