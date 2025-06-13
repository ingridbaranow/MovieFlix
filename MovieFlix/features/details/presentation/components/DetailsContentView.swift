//  DetailsContentView.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 05/06/25.

import UIKit
import SnapKit

class DetailsContentView: UIView {
    
    //MARK: - Components
    
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
    
    lazy var numberOfVotes: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: .bold, size: .body2)
        return label
    }()
    
    lazy var movieYear: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: .bold, size: .body2)
        return label
    }()
    
    lazy var movieRuntime: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = UIFont(name: .bold, size: .body2)
        return label
    }()
    
    lazy var movieDescription: UILabel = {
        let label = UILabel()
        label.textColor = .primaryText
        label.font = UIFont(name: .regular, size: .body2)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var movieDetailsTitle: UILabel = {
        let label = UILabel()
        label.text = "Movie Details"
        label.textColor = .primaryText
        label.font = UIFont(name: .bold, size: .headline2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var statusTitle: UILabel = {
        let label = UILabel()
        label.text = "Status:"
        label.textColor = .lightGray
        label.font = UIFont(name: .bold, size: .body2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var status: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .primaryText
        label.font = UIFont(name: .regular, size: .body2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var originalLanguageTitle: UILabel = {
        let label = UILabel()
        label.text = "Original Language:"
        label.textColor = .lightGray
        label.font = UIFont(name: .bold, size: .body2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var originalLanguage: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .primaryText
        label.font = UIFont(name: .regular, size: .body2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var budgetTitle: UILabel = {
        let label = UILabel()
        label.text = "Budget:"
        label.textColor = .lightGray
        label.font = UIFont(name: .bold, size: .body2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var budget: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .primaryText
        label.font = UIFont(name: .regular, size: .body2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var revenueTitle: UILabel = {
        let label = UILabel()
        label.text = "Revenue:"
        label.textColor = .lightGray
        label.font = UIFont(name: .bold, size: .body2)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var revenue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .primaryText
        label.font = UIFont(name: .regular, size: .body2)
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
        let views = [starSymbol, movieStars, numberOfVotes, movieYear, movieRuntime, movieDescription, movieDetailsTitle, statusTitle, status, originalLanguageTitle, originalLanguage, budgetTitle, budget, revenueTitle, revenue]
        for view in views {
            self.addSubview(view)
        }
    }
    
    // MARK: - View Update with API Data
    
    func valueFormater(value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        if let valorFormatado = formatter.string(from: NSNumber(value: value)) {
            return "$\(valorFormatado)"
        } else {
            return "$\(value)"
        }
    }
    
    func updateTexts(with data: DetailsEntity) {
        let voteAverage = data.voteAverage
        let releaseDate = data.releaseDate
        let language = data.originalLanguage
        let languageUppercased = language.uppercased()
        let budgetFormatted = valueFormater(value: data.budget)
        let revenueFormatted = valueFormater(value: data.revenue)
        
        movieStars.text = String(format: "%.1f", voteAverage)
        numberOfVotes.text = "(\(data.voteCount) votes)"
        movieYear.text = String(releaseDate.prefix(4))
        movieRuntime.text = "\(data.runtime) min"
        movieDescription.text = data.overview
        originalLanguage.text = languageUppercased
        status.text = data.status
        budget.text = budgetFormatted
        revenue.text = revenueFormatted
    }
    
    //MARK: - Setup Constraints
    
    func setupConstraints() {
        starSymbol.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        movieStars.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(starSymbol.snp.right).offset(4)
        }
        numberOfVotes.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(movieStars.snp.right).offset(8)
        }
        movieYear.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(numberOfVotes.snp.right).offset(16)
        }
        movieRuntime.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(movieYear.snp.right).offset(16)
        }
        movieDescription.snp.makeConstraints { make in
            make.top.equalTo(movieStars.snp.bottom).offset(8)
            make.left.equalTo(starSymbol.snp.left)
            make.width.lessThanOrEqualTo(330)
        }
        movieDetailsTitle.snp.makeConstraints { make in
            make.top.equalTo(movieDescription.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(8)
            make.height.equalTo(26)
            make.width.lessThanOrEqualTo(360)
        }
        statusTitle.snp.makeConstraints { make in
            make.top.equalTo(movieDetailsTitle.snp.bottom).offset(20)
            make.left.equalTo(movieDetailsTitle.snp.left)
            make.height.equalTo(16)
        }
        status.snp.makeConstraints { make in
            make.top.equalTo(movieDetailsTitle.snp.bottom).offset(20)
            make.left.equalTo(statusTitle.snp.right).offset(8)
            make.height.equalTo(16)
        }
        originalLanguageTitle.snp.makeConstraints { make in
            make.top.equalTo(statusTitle.snp.bottom).offset(16)
            make.left.equalTo(statusTitle.snp.left)
            make.height.equalTo(16)
        }
        originalLanguage.snp.makeConstraints { make in
            make.top.equalTo(statusTitle.snp.bottom).offset(16)
            make.left.equalTo(originalLanguageTitle.snp.right).offset(8)
            make.height.equalTo(16)
        }
        budgetTitle.snp.makeConstraints { make in
            make.top.equalTo(originalLanguageTitle.snp.bottom).offset(16)
            make.left.equalTo(originalLanguageTitle.snp.left)
            make.height.equalTo(16)
        }
        budget.snp.makeConstraints { make in
            make.top.equalTo(originalLanguageTitle.snp.bottom).offset(16)
            make.left.equalTo(budgetTitle.snp.right).offset(8)
            make.height.equalTo(16)
        }
        revenueTitle.snp.makeConstraints { make in
            make.top.equalTo(budgetTitle.snp.bottom).offset(16)
            make.left.equalTo(budgetTitle.snp.left)
            make.height.equalTo(16)
            make.bottom.equalToSuperview()
        }
        revenue.snp.makeConstraints { make in
            make.top.equalTo(budgetTitle.snp.bottom).offset(16)
            make.left.equalTo(revenueTitle.snp.right).offset(8)
            make.height.equalTo(16)
            make.bottom.equalToSuperview()
        }
    }    
}
