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
    
    @IBOutlet weak var iconBackImage: UIImageView!
    @IBOutlet weak var iconFavoriteImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconBackImage.image = nil
        setupTableView()
        movieService.getMoviesWithCompletion { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movie):
                self.movies = movie.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: MovieCellTableView.identifier, bundle: Bundle(for: MovieCellTableView.self))
        tableView.register(nib, forCellReuseIdentifier: MovieCellTableView.identifier)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCellTableView.identifier,
                                                       for: indexPath) as? MovieCellTableView else {
            return UITableViewCell()
        }
        
        guard let movies else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        cell.configure(title: movie.title ?? "",
                       rating: String(format: "%.1f", movie.voteAverage ?? 0),
                       releaseDate: movie.releaseDate ?? "",
                       language: movie.originalLanguage ?? "",
                       imageUrl: movie.posterPath ?? "")
        if indexPath.row == 0 {
            cell.isFirstCell()
        }
        
        cell.actionAddFavorite = { [weak self] in
            self?.saveMovieToDb(movie) {[weak self] isSuccess, error in
                guard let self else { return }
                print("isSuccess", isSuccess)
                if isSuccess {
                    
                    return
                }
                
            }
        }
        
        cell.actionContentViewCell = { [weak self] in
            guard let self else { return }
            let viewControllerToNavigateTo = DetailViewController(movieId: movie.id ?? 0)
            navigationController?.pushViewController(viewControllerToNavigateTo, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }
        return 136
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
