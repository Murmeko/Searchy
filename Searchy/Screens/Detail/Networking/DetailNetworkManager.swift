//
//  DetailNetworkManager.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 23.07.2023.
//

import Alamofire

class DetailNetworkManager {
    private let basePath = "https://www.omdbapi.com"

    func getContentDetail(for imdbID: String, completion: @escaping ((DetailModel?) -> Void)) {
        let parameters: [String: Any] = [ParameterKeys.token.rawValue: Constants.Search.apiKey,
                                         ParameterKeys.imdbID.rawValue: imdbID,
                                         ParameterKeys.plotSize.rawValue: "short"]

        AF.request(
            basePath,
            parameters: parameters,
            encoding: URLEncoding.queryString
        ).responseDecodable(of: DetailModel.self) { response in
            switch response.result {
            case .success(let detailModel): completion(detailModel)
            case .failure(let error): print(error); completion(nil)
            }
        }
    }
}

extension DetailNetworkManager {
    private enum ParameterKeys: String {
        case token = "apiKey"
        case imdbID = "i"
        case plotSize = "plot"
    }
}
