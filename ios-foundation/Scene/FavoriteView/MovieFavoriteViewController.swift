//
//  MovieFavoriteViewController.swift
//  ios-foundation
//
//  Created by Adhitya Bagasmiwa Permana on 22/01/24.
//

import UIKit

class MovieFavoriteViewController: UIViewController {
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var movieTableView: UITableView!
    
    let movieService = MovieService.shared
    let databaseManager = DatabaseManager()
    var movies: [Movie]?
    var favoriteMovies: [Movie] = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkImage.image = nil
        setupTableView()
        setupTapGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovieList { isSuccess in
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        let nib = UINib(nibName: MovieCellTableView.identifier, bundle: Bundle(for: MovieCellTableView.self))
        movieTableView.register(nib, forCellReuseIdentifier: MovieCellTableView.identifier)
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped))
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backViewTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension MovieFavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }
        return 136
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCellTableView.identifier,
                                                       for: indexPath) as? MovieCellTableView else {
            return UITableViewCell()
        }
        
        let movie = favoriteMovies[indexPath.row]
        cell.configure(title: movie.title ?? "",
                       rating: String(format: "%.1f", movie.voteAverage ?? 0),
                       releaseDate: movie.releaseDate ?? "",
                       language: movie.originalLanguage ?? "",
                       imageUrl: movie.posterPath ?? "",
                       isFavorite: movie.isFavorite ?? false)
        
        if indexPath.row == 0 {
            cell.isFirstCell()
        }
        
        cell.actionRemoveFavorite = { [weak self] in
            guard let self, let movieId = movie.id else { return }
            deleteMovieFavorite(movieId: movieId) { [weak self] success, error  in
                guard let self else { return }
                favoriteMovies.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    tableView.reloadData()
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
    
    func deleteMovieFavorite(movieId: Int, completionHandler: @escaping (Bool, String?) -> Void) {
        databaseManager.deleteMovieFromDb(movieId: movieId) { result in
            switch result {
            case .success(let data):
                completionHandler(data, nil)
            case .failure(let error):
                completionHandler(false, "Error delete movie favorites \(error.localizedDescription)")
            }
        }
    }
    
    func fetchMovieList(completionHandler: @escaping (Bool) -> Void) {
        movieService.getMoviesWithCompletion { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movie):
                self.movies = movie.results
                self.fetchFavoriteMovieList { isSuccess in
                    completionHandler(isSuccess)
                }
            case .failure(let error):
                break
            }
        }
    }
    
    func fetchFavoriteMovieList(completionHandler: @escaping (Bool) -> Void) {
        self.favoriteMovies = []
        self.databaseManager.fetchMovieFromDb { resultDb in
            switch resultDb {
            case .success(let data):
                for movieFavorite in data {
                    let index = self.movies?.firstIndex{ $0.id == movieFavorite.id }
                    guard let index else { continue }
                    if var favMovie = self.movies?[index] {
                        favMovie.isFavorite = true
                        self.favoriteMovies.append(favMovie)
                    }
                }
                completionHandler(true)
            case .failure(let error):
                completionHandler(false)
            }
        }
    }
}
