//
//  MovieService.swift
//  ios-foundation
//
//  Created by Adhitya Bagasmiwa Permana on 22/01/24.
//

import Foundation

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

    private let session: URLSession = {
        let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(Constants.authToken)"
        ]

        let session = URLSession(configuration: sessionConfig)
        return session
    }()
    
    func getMoviesWithCompletion(completionHandler: @escaping ((MoviesResponse) -> Void)) {
        let path = ApiURL.baseURL.rawValue + Endpoint.movieList.rawValue
        guard let url = URL(string: path) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            var result: MoviesResponse
            
            if let error = error {
                result = MoviesResponse.failure(error: error)
            } else if let jsonData = data {
                do {
                    var movie = MovieListResponse()
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(MovieListResponse.self, from: jsonData)
                        movie = MovieListResponse(
                            page: decodedData.page ?? 0,
                            results: decodedData.results ?? [],
                            totalPages: decodedData.totalPages ?? 0,
                            totalResults: decodedData.totalPages ?? 0
                        )
                        debugPrint("Success JSON Response", decodedData)
                    } catch {
                        debugPrint("Error decoding JSON: \(error.localizedDescription)")
                    }
                    
                    result = MoviesResponse.success(movie: movie)
                }
            } else {
                result = MoviesResponse.success(movie: MovieListResponse())
            }
            
            completionHandler(result)
        })
        task.resume()
    }
    
    func getMovieDetailWithCompletion(movieId: Int, completionHandler: @escaping ((MovieDetailResponse) -> Void)) {
        let path = ApiURL.baseURL.rawValue + Endpoint.movie.rawValue + "\(movieId)"
        guard let url = URL(string: path) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            var result: MovieDetailResponse
            
            if let error = error {
                result = MovieDetailResponse.failure(error: error)
            } else if let jsonData = data {
                do {
                    var movie = MovieDetail()
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(MovieDetail.self, from: jsonData)
                        movie = MovieDetail(
                            adult: decodedData.adult ?? false,
                            backdropPath: decodedData.backdropPath ?? "",
                            budget: decodedData.budget ?? 0,
                            genres: decodedData.genres ?? [],
                            homepage: decodedData.homepage ?? "",
                            id: decodedData.id ?? 0,
                            imdbID: decodedData.imdbID ?? "",
                            originalLanguage: decodedData.originalLanguage ?? "",
                            originalTitle: decodedData.originalTitle ?? "",
                            overview: decodedData.overview ?? "",
                            popularity: decodedData.popularity ?? 0.0,
                            posterPath: decodedData.posterPath ?? "",
                            releaseDate: decodedData.releaseDate ?? "",
                            revenue: decodedData.revenue ?? 0,
                            runtime: decodedData.runtime ?? 0,
                            status: decodedData.status ?? "",
                            tagline: decodedData.tagline ?? "",
                            title: decodedData.title ?? "",
                            video: decodedData.video ?? false,
                            voteAverage: decodedData.voteAverage ?? 0.0,
                            voteCount: decodedData.voteCount ?? 0
                        )
                        debugPrint("Success JSON Response", decodedData)
                    } catch {
                        debugPrint("Error decoding JSON: \(error.localizedDescription)")
                    }
                    
                    result = MovieDetailResponse.success(movie: movie)
                }
            } else {
                result = MovieDetailResponse.success(movie: MovieDetail())
            }
            
            completionHandler(result)
        })
        task.resume()
    }
}
