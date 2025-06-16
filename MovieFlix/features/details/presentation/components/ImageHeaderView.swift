//  ImageHeaderView.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 05/06/25.

import UIKit
import SnapKit
import Kingfisher

class ImageHeaderView: UIView {
    
    // MARK: - Callback Functions
    
    var onFavoriteTapped: (() -> Void)?
    
    //MARK: - Components
    
    lazy var movieImageView: GradientImageView2 = {
        let imageView = GradientImageView2(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    lazy var heartBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundDark.withAlphaComponent(0.5)
        view.layer.cornerRadius = 25
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
    
    lazy var movieName: UILabel = {
        let label = UILabel()
        label.textColor = .primaryText
        label.font = UIFont(name: .bold, size: .headline2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var movieTagline: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.font = UIFont(name: .bold, size: .body2)
        label.numberOfLines = 1
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
        let views = [movieImageView, heartBackgroundView, heartImageView, movieName, movieTagline]
        for view in views {
            self.addSubview(view)
        }
    }
    
    // MARK: - View Update with API Data
    
    func updateMovieImage(with data: DetailsEntity) {
        if let path = data.posterPath, let urlPath = URL(string: "https://image.tmdb.org/t/p/w500"+path) {
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
        } else {
            movieImageView.image = UIImage(named: "noPoster")
        }
    }
    
    func updateTexts(with data: DetailsEntity) {
        movieName.text = data.title
        
        if data.tagline == "" {
            movieTagline.text = ""
        } else {
            movieTagline.text = "'\(data.tagline)'"
        }
    }
    
    func updateFavorite(with isFavorite: Bool) {
        heartImageView.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        heartImageView.tintColor = isFavorite ? .primary : .white
    }
    
    //MARK: - Actions
    
    @objc func heartClicked() {
        onFavoriteTapped?()
        print("isFavorite:")
    }
    
    //MARK: - Setup Constraints
    
    func setupConstraints() {
        movieImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 360, height: 360))
        }
        heartBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.top).offset(Int.s2)
            make.right.equalTo(movieImageView.snp.right).inset(Int.s2)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        heartImageView.snp.makeConstraints { make in
            make.center.equalTo(heartBackgroundView)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        movieName.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.top).offset(292)
            make.left.equalTo(movieImageView.snp.left).offset(Int.xs)
            make.width.lessThanOrEqualTo(340)
        }
        movieTagline.snp.makeConstraints { make in
            make.top.equalTo(movieName.snp.bottom).offset(Int.xs)
            make.left.equalTo(movieImageView.snp.left).offset(Int.xs)
            make.width.lessThanOrEqualTo(330)
        }
    }
}



