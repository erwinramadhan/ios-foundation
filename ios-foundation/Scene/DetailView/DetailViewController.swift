//
//  DetailViewController.swift
//  ios-foundation
//
//  Created by Erwin Ramadhan Edwar Putra on 22/01/24.
//

import UIKit

protocol DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}

final class DispatchQueueMock: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}


class DetailViewController: UIViewController {
    
    let mainDispatchQueue: DispatchQueueType
    public var movieService: MovieServiceProtocol = MovieService.shared
    public var databaseManager: DatabaseManagerProtocol = DatabaseManager()
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var bookmarkImage: UIImageView!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var bookmarkDetailIcon: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagStackView: UIStackView!
    
    var movieId: Int?
    var movieDetail: MovieDetail?
    
    init(movieId: Int, mainDispatchQueue: DispatchQueueType = DispatchQueue.main) {
        self.mainDispatchQueue = mainDispatchQueue
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        bookmarkImage.image = nil
        roundTopCorners(view: contentView, radius: 10)
        
        if let movieId {
            fetchMovieDetail(movieId)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func loadPosterImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        Utility().downloadImage(from: url) { [weak self] data in
            guard let self else { return }
            posterImage.image = UIImage(data: data)
            posterImage.contentMode = .scaleAspectFill
        }
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped))
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(tapGesture)
        
        let tapGestureAddToFav = UITapGestureRecognizer(target: self, action: #selector(addToFav))
        bookmarkDetailIcon.isUserInteractionEnabled = true
        bookmarkDetailIcon.addGestureRecognizer(tapGestureAddToFav)
    }
    
    @objc private func backViewTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func addToFav() {
        let movie = Movie(genreIds: [], id: movieId)
        makeMovieFavorite(movie: movie)
    }
    
    func roundTopCorners(view: UIView, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
    
    func setupTags(title: String) {
        let view = TagView()
        view.setData(title: title)
        tagStackView.addArrangedSubview(view)
    }
    
    func makeMovieFavorite(movie: Movie) {
        saveMovieToDb(movie) {[weak self] isSuccess, error in
            guard let self else { return }
            if isSuccess {
                self.bookmarkDetailIcon.image = .init(systemName: "bookmark.fill")
            } else {
                
            }
        }
    }
}

extension DetailViewController {
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
    
    func fetchMovieDetail(_ movieId: Int) {
        movieService.getMovieDetailWithCompletion(movieId: movieId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movie):
                self.movieDetail = movie
                fetchMoviesFavorite { [weak self] movies, error in
                    guard let self else { return }
                    let isFavorite = movies.first{ $0.id == movie.id }?.isFavorite
                    self.movieDetail?.isFavorite = isFavorite
                    mainDispatchQueue.async {
                        self.loadPosterImage(urlString: ApiURL.imageBaseURL.rawValue + (movie.posterPath ?? ""))
                        self.titleLabel.text = movie.originalTitle
                        self.ratingLabel.text = "⭐️ " + String(format: "%.1f", movie.voteAverage ?? 0) + "/10"
                        self.statusLabel.text = movie.status
                        self.languageLabel.text = movie.originalLanguage?.uppercased()
                        self.releaseDateLabel.text = movie.releaseDate
                        self.descriptionLabel.text = movie.overview
                        
                        if isFavorite == true {
                            self.bookmarkDetailIcon.image = .init(systemName: "bookmark.fill")
                        }
                        
                        movie.genres?.forEach{
                            self.setupTags(title: $0.name ?? "")
                        }
                    }
                }
            case .failure(let error):
                break
            }
        }
    }
}
