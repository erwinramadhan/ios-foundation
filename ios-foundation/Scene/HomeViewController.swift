//
//  HomeViewController.swift
//  ios-foundation
//
//  Created by Erwin Ramadhan Edwar Putra on 22/01/24.
//

import UIKit

class HomeViewController: UIViewController {

    let movieService = MovieService.shared
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

extension HomeViewController {
    
    func saveMovieToDb(_ movie: Movie, completionHandler: @escaping ((Bool, String?) -> Void) ) {
        databaseManager.saveMovieToDb(movie: movie, completion: { result in
            switch result {
            case .success(let isSuccess):
                completionHandler(isSuccess, nil)
            case .failure(let error):
                completionHandler(false, "Error save movie db \(error.localizedDescription)")
            }
        })
    }
}
