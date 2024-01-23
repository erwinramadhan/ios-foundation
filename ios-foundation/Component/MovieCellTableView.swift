//
//  MovieCellTableView.swift
//  ios-foundation
//
//  Created by Erwin Ramadhan Edwar Putra on 22/01/24.
//

import UIKit

class MovieCellTableView: UITableViewCell {
    
    public static let identifier = String(describing: MovieCellTableView.self)

    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainImageViewContainer: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var actionAddFavorite: (() -> Void)?
    var actionContentViewCell: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGestureRecognizer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupTapGestureRecognizer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(title: String,
                          rating: String,
                          releaseDate: String,
                          language: String,
                          imageUrl: String,
                          isFavorite: Bool?) {
        titleLabel.text = title
        ratingLabel.text = "⭐️ " + rating + "/10"
        releaseDateLabel.text = releaseDate
        languageLabel.text = "Language: " + language.uppercased()
        favoriteButton.isHidden = isFavorite ?? false
        guard let url = URL(string: ApiURL.imageBaseURL.rawValue + imageUrl) else { return }
        Utility().downloadImage(from: url) { [weak self] data in
            guard let self else { return }
            mainImageView.image = UIImage(data: data)
            mainImageView.layer.cornerRadius = 8
            mainImageView.clipsToBounds = true
        }
    }
    
    public func isFirstCell() {
        contentTopConstraint.constant = 0
    }
    
    @IBAction func didSelectAddToFav(_ sender: Any) {
        actionAddFavorite?()
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapped() {
        actionContentViewCell?()
    }
}
