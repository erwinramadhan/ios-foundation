//
//  MovieFavoriteViewController.swift
//  ios-foundation
//
//  Created by Adhitya Bagasmiwa Permana on 22/01/24.
//

import UIKit

class MovieFavoriteViewController: UIViewController {
    
    let databaseManager = DatabaseManager()
    var moviesFavorite: [Movie] = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MovieFavoriteViewController {
    
    func fetchMoviesFavorite(completionHandler: @escaping ([Movie], String?) -> Void) {
        databaseManager.fetchMovieFromDb(completion: { result in
            switch result {
                case .success(let data):
                completionHandler(data, nil)
                case .failure(let error):
                completionHandler([], "Error get movies favorites \(error.localizedDescription)")
            }
        })
    }
}
