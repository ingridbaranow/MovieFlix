//
//  DetailsViewController.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 05/06/25.
//

import UIKit
import SnapKit

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let detailsViewModel = DetailsViewModel()
    private let detailsView = DetailsView()
    var movieId: Int?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundDark
        view.addSubview(detailsView)
        viewConstraints()
        navigationBarSetup()
        settingUpOnFavoriteButton()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup Constraints
    
    func viewConstraints() {
        detailsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Navigation Bar Setup
    
    func navigationBarSetup() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .primary
    }
    
    // MARK: - Data Request and View Setup
    
    func fetchData() {
        Task {
            do {
                try await detailsViewModel.getMovieDetailsData(id: movieId)
                if let details = detailsViewModel.details {
                    setupViewWithData(data: details)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func setupViewWithData(data: DetailsEntity) {
        detailsView.detailsContentView.updateTexts(with: data)
        detailsView.imageHeaderView.updateMovieImage(with: data)
        detailsView.imageHeaderView.updateTexts(with: data)
        detailsView.imageHeaderView.updateFavorite(with: detailsViewModel.isFavorite(id: movieId))
    }
    
    func settingUpOnFavoriteButton() {
        detailsView.imageHeaderView.onFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            if let movieId = movieId {
                let isFavorited = detailsViewModel.isFavorite(id: movieId)
                detailsView.imageHeaderView.updateFavorite(with: !isFavorited)
                detailsViewModel.toggleFavorite(id: movieId)
            }
        }
    }
}
