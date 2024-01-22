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

class MovieService {

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
    

    func getFoodsWithCompletion(completionHandler: @escaping ((MoviesResponse) -> Void)) {
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
                            page: decodedData.page,
                            results: decodedData.results,
                            totalPages: decodedData.totalPages,
                            totalResults: decodedData.totalPages
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
}
