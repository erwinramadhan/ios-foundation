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
        setupTapGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovieList { isSuccess in
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteIconTapped))
        iconFavoriteImage.isUserInteractionEnabled = true
        iconFavoriteImage.addGestureRecognizer(tapGesture)
    }
    
    @objc private func favoriteIconTapped() {
        let viewControllerToNavigateTo = MovieFavoriteViewController()
        navigationController?.pushViewController(viewControllerToNavigateTo, animated: true)
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
                       imageUrl: movie.posterPath ?? "",
                       isFavorite: movie.isFavorite ?? false,
                       isHome: true)
        
        if indexPath.row == 0 {
            cell.isFirstCell()
        }
        
        cell.actionAddFavorite = { [weak self] in
            self?.saveMovieToDb(movie) {[weak self] isSuccess, error in
                guard let self else { return }
                if isSuccess {
                    self.fetchFavoriteMovieList { result in
                        cell.favoriteButton.isHidden = result
                    }
                } else {
                    
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
        self.databaseManager.fetchMovieFromDb { resultDb in
            switch resultDb {
            case .success(let data):
                for movieFavorite in data {
                    let index = self.movies?.firstIndex{ $0.id == movieFavorite.id }
                    guard let index else { continue }
                    self.movies?[index].isFavorite = movieFavorite.isFavorite ?? false
                    
                }
                completionHandler(true)
            case .failure(let error):
                completionHandler(false)
            }
        }
    }
}
