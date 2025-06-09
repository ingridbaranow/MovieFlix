//  MovieCell.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 02/06/25.

import UIKit
import SnapKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    
    var homeEntity: HomeResponse?
    
    var onFavoriteTapped: (() -> Void)?
    
    //MARK: - Components
    
    lazy var movieImageView: GradientImageView2 = {
        let imageView = GradientImageView2(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var heartBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundDark.withAlphaComponent(0.5)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    lazy var heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        let gesture = UITapGestureRecognizer(target: self, action: #selector(heartClicked))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        return imageView
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
        label.textColor = .primaryText
        label.font = UIFont(name: .regular, size: .body2)
        return label
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
        addSubview(contentView)
        let views = [movieImageView, heartBackgroundView, heartImageView, starSymbol, movieStars, movieYear]
        for view in views {
            contentView.addSubview(view)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    func updateCell(with movie: MovieEntity) {
        let voteAverage = movie.voteAverage
        let releaseDate = movie.releaseDate
        if let path = movie.posterPath, let urlPath = URL(string: "https://image.tmdb.org/t/p/w500"+path) {
            let processor = DownsamplingImageProcessor(size: movieImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 8)
            movieImageView.kf.indicatorType = .activity
            movieImageView.kf.setImage(
                with: urlPath,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
        movieStars.text = String(format: "%.1f", voteAverage)
        movieYear.text = String(releaseDate.prefix(4))
        
        if movie.isFavorite == false {
            heartImageView.image = UIImage(systemName: "heart")
            heartImageView.tintColor = .white
        } else {
            heartImageView.image = UIImage(systemName: "heart.fill")
            heartImageView.tintColor = .primary
        }
    }
    
    //MARK: - Actions
    
    @objc func heartClicked() {
        onFavoriteTapped?()
        print("favorite")
    }
    
    //MARK: - Constraints
    
    func setupConstraints() {
        movieImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        heartBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.top).offset(8)
            make.right.equalTo(movieImageView.snp.right).inset(8)
            make.size.equalTo(CGSize(width: 33, height: 33))
        }
        heartImageView.snp.makeConstraints { make in
            make.center.equalTo(heartBackgroundView)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        starSymbol.snp.makeConstraints { make in
            make.bottom.equalTo(movieImageView.snp.bottom).inset(15)
            make.left.equalTo(movieImageView.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        movieStars.snp.makeConstraints { make in
            make.bottom.equalTo(movieImageView.snp.bottom).inset(14)
            make.left.equalTo(starSymbol.snp.right).offset(4)
        }
        movieYear.snp.makeConstraints { make in
            make.bottom.equalTo(movieImageView.snp.bottom).inset(14)
            make.right.equalTo(movieImageView.snp.right).inset(16)
        }
    }
}
