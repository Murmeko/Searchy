//
//  SearchNetworkManager.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import Alamofire

class SearchNetworkManager {
  private let basePath = "https://www.omdbapi.com"

  func getSearchResults(for text: String, pageNumber: Int? = nil, completion: @escaping ((SearchModel?) -> Void)) {
    let parameters: [String: Any] = [ParameterKeys.token.rawValue: Constants.Search.apiKey,
                                     ParameterKeys.searchText.rawValue: text,
                                     ParameterKeys.pageNumber.rawValue: pageNumber ?? 1]
    AF.request(basePath, parameters: parameters).responseDecodable(of: SearchModel.self) { response in
      switch response.result {
      case .success(let searchModel): completion(searchModel)
      case .failure(let error): print(error); completion(nil)
      }
    }
  }
}

extension SearchNetworkManager {
  private enum ParameterKeys: String {
    case token = "apiKey"
    case searchText = "s"
    case pageNumber = "page"
  }
}
