//
//  DetailViewModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import Foundation

protocol DetailViewModelProtocol: BaseViewModelProtocol {
  var router: DetailRouterProtocol { get set }

  var titleLabelText: String? { get }
  var genreLabelText: String? { get }
  var releaseDateLabelText: String? { get }
  var summaryLabelText: String? { get }

  var updateView: (() -> Void)? { get set }
}

class DetailViewModel: DetailViewModelProtocol {
  var router: DetailRouterProtocol = DetailRouter()

  var titleLabelText: String?
  var genreLabelText: String?
  var releaseDateLabelText: String?
  var summaryLabelText: String?

  var updateView: (() -> Void)?

  private let imdbID: String

  private var networkManager = DetailNetworkManager()

  init(with imdbID: String) {
    self.imdbID = imdbID
  }

  func viewIsReady() {
    fetchContentDetail(for: imdbID)
  }
}

extension DetailViewModel {
  private func fetchContentDetail(for imdbID: String) {
    networkManager.getContentDetail(for: imdbID) { [weak self] detailModel in
      guard let self = self else { return }
      guard let detailModel = detailModel else { return }
      self.titleLabelText = detailModel.title
      self.genreLabelText = detailModel.genre
      self.releaseDateLabelText = detailModel.released
      self.summaryLabelText = detailModel.plot
      self.updateView?()
    }
  }
}
