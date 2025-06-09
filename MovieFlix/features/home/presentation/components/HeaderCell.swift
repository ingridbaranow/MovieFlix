//  HeaderCell.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 02/06/25.

import UIKit
import SnapKit
import Kingfisher

class HeaderCell: UICollectionViewCell {
    
    var onFavoriteTapped: (() -> Void)?
    var onDetailsTapped: (() -> Void)?
    
    //MARK: - Components
    
    lazy var hypeMovieImageView: GradientImageView = {
        let imageView = GradientImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    lazy var movieName: UILabel = {
        let label = UILabel()
        label.textColor = .primaryText
        label.font = UIFont(name: .bold, size: .headline2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var movieDescription: UILabel = {
        let label = UILabel()
        label.textColor = .primaryText
        label.font = UIFont(name: .regular, size: .body2)
        label.numberOfLines = 3
        return label
    }()
    
    lazy var starSymbol: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .primary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var movieStars: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.font = UIFont(name: .bold, size: .body1)
        return label
    }()
    
    lazy var movieYear: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: .bold, size: .body2)
        return label
    }()
    
    lazy var detailsButton: UIButton = {
        let button = UIButton()
        button.setTitle("View Details", for: .normal)
        button.setTitleColor(.backgroundDark, for: .normal)
        button.titleLabel?.font = UIFont(name: .bold, size: .body3)
        button.backgroundColor = .primary
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(detailsTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var addToFavoritesButton: DefaultOutlineButton = {
        let button = DefaultOutlineButton()
        button.setupButton(title: "Add to Favorites", imageName: "heart")
        button.addTarget(self, action: #selector(addToFavoritesTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        let views = [hypeMovieImageView, movieName, movieDescription, starSymbol, movieStars, movieYear, detailsButton, addToFavoritesButton]
        for view in views {
            self.addSubview(view)
        }
    }
    
    func updateCell(with movie: MovieEntity) {
        let voteAverage = movie.voteAverage
        let releaseDate = movie.releaseDate
        if let path = movie.posterPath, let urlPath = URL(string: "https://image.tmdb.org/t/p/w500"+path) {
            let processor = DownsamplingImageProcessor(size: hypeMovieImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 8)
            hypeMovieImageView.kf.indicatorType = .activity
            hypeMovieImageView.kf.setImage(
                with: urlPath,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
        movieName.text = movie.title
        movieDescription.text = movie.overview
        movieStars.text = String(format: "%.1f", voteAverage)
        movieYear.text = String(releaseDate.prefix(4))
        if movie.isFavorite == false {
            addToFavoritesButton.socialImage.image = UIImage(systemName: "heart")
        } else {
            addToFavoritesButton.socialImage.image = UIImage(systemName: "heart.fill")
        }
    }
    
    //MARK: - Actions
    
    @objc func addToFavoritesTapped(){
        onFavoriteTapped?()
        print("add to favorite")
    }
    
    @objc func detailsTapped(){
        onDetailsTapped?()
        print("details")
        
    }
    
    //MARK: - Setup Constraints
    
    func setupConstraints() {
        hypeMovieImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(360)
            make.bottom.equalToSuperview()
        }
        movieName.snp.makeConstraints { make in
            make.top.equalTo(hypeMovieImageView.snp.top).offset(190)
            make.left.equalTo(hypeMovieImageView.snp.left).offset(16)
            make.width.lessThanOrEqualTo(340)
        }
        movieDescription.snp.makeConstraints { make in
            make.top.equalTo(movieName.snp.bottom).offset(8)
            make.left.equalTo(movieName.snp.left)
            make.width.lessThanOrEqualTo(330)
        }
        starSymbol.snp.makeConstraints { make in
            make.top.equalTo(movieDescription.snp.bottom).offset(16)
            make.left.equalTo(movieDescription.snp.left)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        movieStars.snp.makeConstraints { make in
            make.top.equalTo(movieDescription.snp.bottom).offset(18)
            make.left.equalTo(starSymbol.snp.right).offset(8)
        }
        movieYear.snp.makeConstraints { make in
            make.top.equalTo(movieDescription.snp.bottom).offset(19)
            make.left.equalTo(movieStars.snp.right).offset(16)
        }
        detailsButton.snp.makeConstraints { make in
            make.top.equalTo(starSymbol.snp.bottom).offset(16)
            make.left.equalTo(starSymbol.snp.left)
            make.height.equalTo(40)
            make.width.greaterThanOrEqualTo(120)
        }
        addToFavoritesButton.snp.makeConstraints { make in
            make.top.equalTo(starSymbol.snp.bottom).offset(16)
            make.left.equalTo(detailsButton.snp.right).offset(8)
            make.height.equalTo(40)
            make.width.greaterThanOrEqualTo(160)
        }
    }
}



