//
//  DetailViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import Foundation
import FirebaseAnalytics

protocol DetailViewModelProtocol: BaseViewModelProtocol {
  var router: DetailRouterProtocol { get set }

  var titleLabelText: String? { get }
  var genreLabelText: String? { get }
  var releaseDateLabelText: String? { get }
  var summaryLabelText: String? { get }

  var activityIndicatorStartAnimating: (() -> Void)? { get set }
  var activityIndicatorStopAnimating: (() -> Void)? { get set }

  var animateViewAppear: (() -> Void)? { get set }
  var updateView: (() -> Void)? { get set }
}

class DetailViewModel: DetailViewModelProtocol {
  var router: DetailRouterProtocol = DetailRouter()

  var titleLabelText: String?
  var genreLabelText: String?
  var releaseDateLabelText: String?
  var summaryLabelText: String?

  var activityIndicatorStartAnimating: (() -> Void)?
  var activityIndicatorStopAnimating: (() -> Void)?

  var animateViewAppear: (() -> Void)?
  var updateView: (() -> Void)?

  private let imdbID: String

  private var networkManager = DetailNetworkManager()

  init(with imdbID: String) {
    self.imdbID = imdbID
  }

  func viewIsReady() {
    activityIndicatorStartAnimating?()
    fetchContentDetail(for: imdbID)
  }
}

extension DetailViewModel {
  private func fetchContentDetail(for imdbID: String) {
    networkManager.getContentDetail(for: imdbID) { [weak self] detailModel in
      guard let self = self, let detailModel = detailModel else { self?.router.dismissViewController?(); return }
      handleFetchContentDetail(detailModel)
      guard let contentTitle = detailModel.title else { return }
      logEvent(with: imdbID, contentTitle)
    }
  }

  private func handleFetchContentDetail(_ detailModel: DetailModel) {
    titleLabelText = detailModel.title
    genreLabelText = detailModel.genre
    releaseDateLabelText = detailModel.released
    summaryLabelText = detailModel.plot

    activityIndicatorStopAnimating?()
    updateView?()
    animateViewAppear?()
  }
}

extension DetailViewModel {
  private func logEvent(with imdbID: String, _ contentTitle: String) {
    Analytics.logEvent("entered_content_detail_view", parameters: [
      "imdb_id": imdbID as NSObject,
      "content_title": contentTitle as NSObject
    ])
  }
}
