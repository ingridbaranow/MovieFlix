//  SectionView.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 02/06/25.

import UIKit
import SnapKit

class SectionView: UICollectionReusableView {
    
    //MARK: - Components
    
    lazy var movieCategory: UILabel = {
        let movieCategory = UILabel()
        movieCategory.textColor = .primaryText
        movieCategory.font = UIFont(name: .bold, size: .headline3)
        movieCategory.numberOfLines = 1
        movieCategory.text = "Popular Movies"
        return movieCategory
    }()
    
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        sectionSetup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        self.addSubview(movieCategory)
    }
    
    func sectionSetup() {
        backgroundColor = .backgroundDark
    }
    
    //MARK: - Constraints
    
    func setupConstraints() {
        movieCategory.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
        }
    }
}

