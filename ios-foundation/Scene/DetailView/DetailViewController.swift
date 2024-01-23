//
//  DetailViewController.swift
//  ios-foundation
//
//  Created by Erwin Ramadhan Edwar Putra on 22/01/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    let movieService = MovieService.shared

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var bookmarkImage: UIImageView!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movieId: Int?
    var movieDetail: MovieDetail?
    
    init(movieId: Int) {
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
        
        if let movieId {
            movieService.getMovieDetailWithCompletion(movieId: movieId) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let movie):
                    self.movieDetail = movie
                    DispatchQueue.main.async {
                        self.loadPosterImage(urlString: ApiURL.imageBaseURL.rawValue + (movie.posterPath ?? ""))
                        self.titleLabel.text = movie.originalTitle
                        self.ratingLabel.text = "⭐️ " + String(format: "%.1f", movie.voteAverage ?? 0) + "/10"
                        self.statusLabel.text = movie.status
                        self.languageLabel.text = movie.originalLanguage
                        self.releaseDateLabel.text = movie.releaseDate
                        self.descriptionLabel.text = movie.overview
                    }
                case .failure(let error):
                    break
                }
            }
        }
        
       
        roundTopCorners(view: contentView, radius: 10)
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
    }
    
    @objc private func backViewTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func roundTopCorners(view: UIView, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: radius, height: radius))

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
    
    private func setupCollectionView() {
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }

}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
