//
//  MovieFavoriteViewController.swift
//  ios-foundation
//
//  Created by Adhitya Bagasmiwa Permana on 22/01/24.
//

import UIKit

class MovieFavoriteViewController: UIViewController {
    @IBOutlet weak var movieTableView: UITableView!
    
    let databaseManager = DatabaseManager()
    var moviesFavorite: [Movie] = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupMovieTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
    }
}

extension MovieFavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
