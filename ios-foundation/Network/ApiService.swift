//
//  ApiService.swift
//  ios-foundation
//
//  Created by Adhitya Bagasmiwa Permana on 22/01/24.
//

import Foundation

enum Endpoint: String {
    case movieList = "movie/now_playing"
    case movie = "movie/"
}

enum ApiURL: String {
    case baseURL = "https://api.themoviedb.org/3/"
    case imageBaseURL = "https://image.tmdb.org/t/p/w500"
}
