//  HomeViewController.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 30/05/25.

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeViewModel = HomeViewModel()
    private let homeView = HomeView()
    var isPageRefreshing: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundDark
        view.addSubview(homeView)
        viewConstraints()
        navigationBarSetup()
        collectionViewDelegate()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeView.collectionView.reloadData()
    }
    
    // MARK: - Setup Constraints
    
    func viewConstraints() {
        homeView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Navigation Bar Setup
    
    func navigationBarSetup() {
        title = "MovieFlix"
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
    
    // MARK: - Data Request and View Setup
    
    func fetchData() {
        Task {
            do {
                try await homeViewModel.getMovieListData()
                homeView.collectionView.reloadData()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if position > contentHeight - frameHeight * 1.3, !isPageRefreshing {
            isPageRefreshing = true
            homeViewModel.incrementPage()
            Task {
                do {
                    try await homeViewModel.getMovieListData()
                    homeView.collectionView.reloadData()
                    isPageRefreshing = false
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - CollectionView Delegate
    
    func collectionViewDelegate() {
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
    }
    
    //MARK: - CollectionView HeaderSection
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return max(homeViewModel.filmes.count - 1, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionView", for: indexPath) as! SectionView
        return header
    }
    
    //MARK: - CollectionView Layouts
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 0)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 45)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 400)
        } else {
            let spacing: CGFloat = 16
            let totalSpacing = spacing * (2 - 1)
            let width = (collectionView.bounds.width - totalSpacing) / 2
            return CGSize(width: width, height: width * 1.5)
        }
    }
    
    //MARK: - CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            if let firstMovie = homeViewModel.filmes.first {
                cell.updateMovieImage(with: firstMovie)
                cell.updateTexts(with: firstMovie)
                cell.updateFavorite(with: homeViewModel.isFavorite(id: firstMovie.id))
            }
            
            cell.onFavoriteTapped = { [weak self] in
                guard let self = self else { return }
                let movieId = self.homeViewModel.filmes[0].id
                let isFavorited = homeViewModel.isFavorite(id: movieId)
                cell.updateFavorite(with: !isFavorited)
                homeViewModel.toggleFavorite(id: movieId)
                self.homeView.collectionView.reloadItems(at: [indexPath])
            }
            
            cell.onDetailsTapped = { [weak self] in
                var selectedMovie: MovieEntity?
                if indexPath.section == 0 {
                    selectedMovie = self?.homeViewModel.filmes.first
                }
                guard let movie = selectedMovie else { return }
                let detailsVC = DetailsViewController()
                detailsVC.movieId = movie.id
                self?.navigationController?.pushViewController(detailsVC, animated: true)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.updateMovieImage(with: homeViewModel.filmes[indexPath.row + 1])
            cell.updateTexts(with: homeViewModel.filmes[indexPath.row + 1])
            cell.updateFavorite(with: homeViewModel.isFavorite(id: homeViewModel.filmes[indexPath.row + 1].id))
            
            cell.onFavoriteTapped = { [weak self] in
                guard let self = self else { return }
                let index = indexPath.row + 1
                let movieId = self.homeViewModel.filmes[index].id
                let isFavorited = homeViewModel.isFavorite(id: movieId)
                cell.updateFavorite(with: !isFavorited)
                homeViewModel.toggleFavorite(id: movieId)
                self.homeView.collectionView.reloadItems(at: [indexPath])
            }
            return cell
        }
    }
    
    //MARK: - Navigation to DetailsViewController
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedMovie: MovieEntity?
        
        if indexPath.section == 0 {
            selectedMovie = homeViewModel.filmes.first
        } else {
            selectedMovie = homeViewModel.filmes[indexPath.item + 1]
        }
        
        guard let movie = selectedMovie else { return }
        
        let detailsVC = DetailsViewController()
        detailsVC.movieId = movie.id
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
