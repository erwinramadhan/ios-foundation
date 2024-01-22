//
//  DatabaseManager.swift
//  ios-foundation
//
//  Created by Adhitya Bagasmiwa Permana on 22/01/24.
//

import Foundation
import CoreData

class DatabaseManager: NSObject {
    
    func saveMovieToDb(movie: Movie, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        let context = CoreDataContainer.persistentContainer.viewContext
        let newMovie = MovieDB(context: context)
        
        newMovie.id = Int64(movie.id ?? .zero)
        newMovie.name = movie.title
        newMovie.voteAverage = movie.voteAverage ?? .zero
        newMovie.posterPath = movie.posterPath ?? ""
        newMovie.isFavorite = true
        
        CoreDataContainer.saveContext(completion: { result in
            switch result {
                case .success(let isSuccess):
                    completion(.success(isSuccess))
                case .failure(let error):
                    completion(.failure(error))
            }
        })
    }
    
    func fetchMovieFromDb(completion: @escaping ((Result<[Movie], Error>) -> Void)) {
        let context = CoreDataContainer.persistentContainer.viewContext
        var movies = [Movie]()
        
        do {
            let moviesDb: [MovieDB] = try context.fetch(MovieDB.fetchRequest())
            if moviesDb.count > 0 {
                for movie in moviesDb {
                    let data = Movie(
                        adult: false,
                        backdropPath: "",
                        genreIds: [],
                        id: Int(movie.id),
                        originalLanguage: "",
                        originalTitle: "",
                        overview: "",
                        popularity: 0.0,
                        posterPath: movie.posterPath,
                        releaseDate: "",
                        title: movie.name ?? "",
                        video: false,
                        voteAverage: movie.voteAverage,
                        voteCount: 0,
                        isFavorite: movie.isFavorite
                    )
                    movies.append(data)
                }
            }
            completion(.success(movies))
        } catch let error {
            debugPrint("[LOG - Error Get Core Data]: ", error)
            completion(.failure(error))
        }
    }
}
