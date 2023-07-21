//
//  SearchNetworkManager.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import Alamofire

class SearchNetworkManager {
  private let basePath = "https://www.omdbapi.com"
  
  func getSearchResults(for text: String, completion: @escaping ((SearchModel?) -> Void)) {
    let parameters: [String: Any] = ["apiKey": Constants.Search.apiKey,
                                     "s": text]
    AF.request(basePath, parameters: parameters).responseDecodable(of: SearchModel.self) { response in
      switch response.result {
      case .success(let searchModel): completion(searchModel)
      case .failure(let error): print(error); completion(nil)
      }
    }
  }
}
