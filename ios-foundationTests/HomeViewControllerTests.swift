//
//  HomeViewControllerTests.swift
//  ios-foundationTests
//
//  Created by Erwin Ramadhan Edwar Putra on 24/01/24.
//

import XCTest
@testable import ios_foundation

class MovieServiceMock: MovieServiceProtocol {
    var isGetMovieCalled = false
    var isGetMovieDetailCalled = false
    
    func getMoviesWithCompletion(completionHandler: @escaping ((MoviesResponse) -> Void)) {
        isGetMovieCalled = true
        completionHandler(.success(movie: .init(results: [Movie(genreIds: [0], originalTitle: "Habibie & Ainun 3", title: "Habibie & Ainun 3")])))
    }
}

class HomeViewControllerTests: XCTestCase {
    var sut: HomeViewController!
    var movieServiceMock: MovieServiceMock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        makeSutHomeVC()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        movieServiceMock = nil
    }
    
    func makeSutHomeVC() {
        sut = HomeViewController()
        movieServiceMock = MovieServiceMock()
        
        sut.movieService = movieServiceMock
    }
    
    func testFetchMovieList() {
        sut.fetchMovieList(completionHandler: { isSuccess, movies in
            if isSuccess {
                XCTAssertEqual(movies, self.sut.movies)
            } else {
                XCTAssertEqual(nil, self.sut.movies)
            }
        })
        
        XCTAssert(movieServiceMock.isGetMovieCalled)
    }
}
