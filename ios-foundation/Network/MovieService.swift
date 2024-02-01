//
//  MovieService.swift
//  ios-foundation
//
//  Created by Adhitya Bagasmiwa Permana on 22/01/24.
//

import Foundation
import Alamofire

enum MoviesResponse {
    case success(movie: MovieListResponse)
    case failure(error: Error)
}

enum MovieDetailResponse {
    case success(movie: MovieDetail)
    case failure(error: Error)
}

protocol MovieServiceProtocol {
    func getMoviesWithCompletion(completionHandler: @escaping ((MoviesResponse) -> Void))
    func getMovieDetailWithCompletion(movieId: Int, completionHandler: @escaping ((MovieDetailResponse) -> Void))
}

class MovieService: MovieServiceProtocol {

    static let shared = MovieService()

    let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Authorization": "Bearer \(Constants.authToken)"
    ]
    
    func getMoviesWithCompletion(completionHandler: @escaping ((MoviesResponse) -> Void)) {
        let path = ApiURL.baseURL.rawValue + Endpoint.movieList.rawValue
        guard let url = URL(string: path) else {
            return
        }
        var result: MoviesResponse?
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    result = MoviesResponse.success(movie: data)
                    if let result {
                        completionHandler(result)
                    }
                case .failure(let error):
                    result = MoviesResponse.failure(error: error)
                    if let result {
                        completionHandler(result)
                    }
                }
        }
    }
    
    func getMovieDetailWithCompletion(movieId: Int, completionHandler: @escaping ((MovieDetailResponse) -> Void)) {
        let path = ApiURL.baseURL.rawValue + Endpoint.movie.rawValue + "\(movieId)"
        guard let url = URL(string: path) else {
            return
        }

        var result: MovieDetailResponse?
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: MovieDetail.self) { response in
                switch response.result {
                case .success(let data):
                    result = MovieDetailResponse.success(movie: data)
                    if let result {
                        completionHandler(result)
                    }
                case .failure(let error):
                    result = MovieDetailResponse.failure(error: error)
                    if let result {
                        completionHandler(result)
                    }
                }
        }
    }
}
