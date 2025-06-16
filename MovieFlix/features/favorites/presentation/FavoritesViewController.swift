//  FavoritesViewController.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 10/06/25.

import UIKit
import SnapKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let favoritesViewModel = FavoritesViewModel()
    private let favoritesView = FavoritesView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundDark
        view.addSubview(favoritesView)
        viewConstraints()
        navigationBarSetup()
        collectionViewDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    // MARK: - Data Request and View Setup
    
    func fetchFavorites() {
        Task {
            do {
                try await favoritesViewModel.getFavoritesListData()
                favoritesView.collectionView.reloadData()
            } catch {
                print("Error by fetching data: \(error)")
            }
        }
    }
    
    // MARK: - Setup Constraints
    
    func viewConstraints() {
        favoritesView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Navigation Bar Setup
    
    func navigationBarSetup() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .inline
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundDark
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.primary]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.primary]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - CollectionView Delegate
    
    func collectionViewDelegate() {
        favoritesView.collectionView.delegate = self
        favoritesView.collectionView.dataSource = self
    }
    
    //MARK: - CollectionView Section Setup
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesViewModel.favorites.count
    }
    
    //MARK: - CollectionView Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        let totalSpacing = spacing * (2 - 1)
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    //MARK: - CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let movie = favoritesViewModel.favorites[indexPath.row]
        cell.updateMovieImage(with: movie)
        cell.updateTexts(with: movie)
        
        cell.onFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            let movieId = movie.id
            self.favoritesViewModel.toggleFavorite(id: movieId)
            if let index = self.favoritesViewModel.favorites.firstIndex(where: { $0.id == movieId }) {
                self.favoritesViewModel.favorites.remove(at: index)
                self.favoritesView.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
        }
        return cell
    }
    
    //MARK: - Navigation to DetailsViewController
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = favoritesViewModel.favorites[indexPath.item]
        
        let detailsVC = DetailsViewController()
        detailsVC.movieId = selectedMovie.id
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
