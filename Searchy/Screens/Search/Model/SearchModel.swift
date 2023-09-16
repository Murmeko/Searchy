//
//  SearchModel.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import Foundation

// MARK: - SearchModel
struct SearchModel: Codable {
    let search: [SearchResultModel]?
    let totalResults: String?
    let response: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
}

// MARK: - SearchResultModel
struct SearchResultModel: Codable {
    let title: String?
    let year: String?
    let imdbId: String?
    let type: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbId = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
