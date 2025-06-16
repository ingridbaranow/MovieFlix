//  FavoritesView.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 10/06/25.

import UIKit
import SnapKit

class FavoritesView: UIView {
    
    //MARK: - Components
    
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
        addSubview(collectionView)
    }
    
    func collectionViewRegisterCell() {
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavoriteCell")
    }
    
    
    //MARK: - Constraints
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Int.s1)
            make.right.equalToSuperview().inset(Int.s1)
            make.bottom.equalToSuperview()
        }
    }
}


