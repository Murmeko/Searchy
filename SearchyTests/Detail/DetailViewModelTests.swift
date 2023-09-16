//
//  DetailViewModelTests.swift
//  SearchyTests
//
//  Created by Yiğit Erdinç on 26.07.2023.
//

import XCTest
@testable import Searchy

class DetailViewModelTests: XCTestCase {
    func testFetchContentDetailHandler() {
        let viewModel = DetailViewModel(with: "tt0482571")

        let mockTitleLabelText = "Mock Title"
        let mockGenreLabelText = "Mock Genres"
        let mockReleaseDateLabelText = "Mock Release Date"
        let mockSummaryLabelText = "Test Plot"

        let mockDetailModel = DetailModel(
            title: mockTitleLabelText,
            year: nil,
            rated: nil,
            released: mockReleaseDateLabelText,
            runtime: nil,
            genre: mockGenreLabelText,
            director: nil,
            writer: nil,
            actors: nil,
            plot: mockSummaryLabelText,
            language: nil,
            country: nil,
            awards: nil,
            poster: nil,
            ratings: nil,
            metascore: "Test Metascore",
            imdbRating: "Test Rating",
            imdbVotes: "Test Votes",
            imdbId: "Test ID",
            type: nil,
            boxOffice: nil,
            production: nil,
            website: nil,
            response: nil
        )

        viewModel.handleFetchContentDetail(mockDetailModel)

        XCTAssertEqual(viewModel.titleLabelText, mockTitleLabelText, "Titles do not match.")
        XCTAssertEqual(viewModel.genreLabelText, mockGenreLabelText, "Genres do not match.")
        XCTAssertEqual(viewModel.releaseDateLabelText, mockReleaseDateLabelText, "Release dates do not match.")
        XCTAssertEqual(viewModel.summaryLabelText, mockSummaryLabelText, "Summaries do not match.")
    }
}
