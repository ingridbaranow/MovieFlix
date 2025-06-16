//  HomeView.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 02/06/25.

import UIKit
import SnapKit

class HomeView: UIView {
    
    //MARK: - Components
    
    lazy var searchBar: DefaultSearchBar = {
        let searchBar = DefaultSearchBar()
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backgroundDark
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        collectionViewRegisterCell()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        addSubview(searchBar)
        addSubview(collectionView)
    }
    
    func collectionViewRegisterCell() {
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: "HeaderCell")
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.register(SectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionView")
    }
    
    
    //MARK: - Constraints
    
    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Int.s2)
            make.size.equalTo(CGSize(width: 360, height: 40))
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Int.s2)
            make.left.equalToSuperview().offset(Int.s1)
            make.right.equalToSuperview().inset(Int.s1)
            make.bottom.equalToSuperview()
        }
    }
}
