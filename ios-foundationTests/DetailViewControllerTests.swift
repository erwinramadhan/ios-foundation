//
//  DetailViewControllerTests.swift
//  ios-foundationTests
//
//  Created by Erwin Ramadhan Edwar Putra on 25/01/24.
//

import XCTest
@testable import ios_foundation

class DatabaseManagerMock: NSObject, DatabaseManagerProtocol {
    var isfetchMovieFromDbCalled = false
    
    func fetchMovieFromDb(completion: @escaping ((Result<[Movie], Error>) -> Void)) {
        let moviesFav: [Movie] = [Movie(genreIds: [], id: 787699, title: "Wonka", isFavorite: true)]
        completion(.success(moviesFav))
        isfetchMovieFromDbCalled = true
    }
}

extension MovieServiceMock {
    func getMovieDetailWithCompletion(movieId: Int, completionHandler: @escaping ((ios_foundation.MovieDetailResponse) -> Void)) {
        isGetMovieDetailCalled = true
        completionHandler(.success(movie: MovieDetail(genres: [Genre(id: 35, name: "Comedy"),
                                                         Genre(id: 10751, name: "Family"),
                                                         Genre(id: 14, name: "Fantasy")],
                                                id: 787699,
                                                overview: "Willy Wonka – chock-full of ideas and determined to change the world one delectable bite at a time – is proof that the best things in life begin with a dream, and if you’re lucky enough to meet Willy Wonka, anything is possible.",
                                                releaseDate: "2023-12-06",
                                                status: "Released",
                                                title: "Wonka",
                                                voteAverage: 7.2,
                                                isFavorite: false)))
    }
}

class DetailViewControllerTests: XCTestCase {
    var sut: DetailViewController!
    var movieServiceMock: MovieServiceMock!
    var databaseManagerMock: DatabaseManagerMock!
    var movieDetail: MovieDetail!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // MARK: Given
        movieDetail = MovieDetail(genres: [Genre(id: 35, name: "Comedy"),
                                           Genre(id: 10751, name: "Family"),
                                           Genre(id: 14, name: "Fantasy")],
                                  id: 787699,
                                  overview: "Willy Wonka – chock-full of ideas and determined to change the world one delectable bite at a time – is proof that the best things in life begin with a dream, and if you’re lucky enough to meet Willy Wonka, anything is possible.",
                                  releaseDate: "2023-12-06",
                                  status: "Released",
                                  title: "Wonka",
                                  voteAverage: 7.2,
                                  isFavorite: true)
        sut = DetailViewController(movieId: movieDetail.id ?? 0)
        movieServiceMock = MovieServiceMock()
        databaseManagerMock = DatabaseManagerMock()
        
        sut.movieService = movieServiceMock
        sut.databaseManager = databaseManagerMock
        sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        movieServiceMock = nil
        databaseManagerMock = nil
        movieDetail = nil
    }
    
    func testFetchMovieDetail() {
        // MARK: When
        sut.viewDidLoad()
        
        // MARK: Then
        XCTAssertEqual(sut.movieDetail?.id, movieDetail.id)
        XCTAssertEqual(sut.movieDetail?.title, movieDetail.title)
        XCTAssertEqual(sut.movieDetail?.voteAverage, movieDetail.voteAverage)
        XCTAssertEqual(sut.movieDetail?.genres, movieDetail.genres)
        XCTAssertEqual(sut.movieDetail?.status, movieDetail.status)
        XCTAssertEqual(sut.movieDetail?.originalLanguage, movieDetail.originalLanguage)
        XCTAssertEqual(sut.movieDetail?.overview, movieDetail.overview)
        XCTAssertEqual(sut.movieDetail?.isFavorite, movieDetail.isFavorite)
        XCTAssert(movieServiceMock.isGetMovieDetailCalled)
        XCTAssert(databaseManagerMock.isfetchMovieFromDbCalled)
    }
}
