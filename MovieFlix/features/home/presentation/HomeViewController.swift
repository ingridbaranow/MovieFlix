//  HomeViewController.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 30/05/25.

import UIKit

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    var filmes: [MovieEntity] = []
    var response: HomeResponse?
    var page: Int = 1
    var isPageRefreshing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundDark
        view.addSubview(homeView)
        viewConstraints()
        collectionViewDelegate()
        Task {
            do {
                try await getMovieListData()
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
            page += 1
            Task {
                do {
                    try await getMovieListData()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func getMovieListData() async throws -> Void {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let mypage = String(page)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: mypage),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwYjJmZWJmMTk1ZTUyYTdkN2IzYzA1Nzg1NDBlNWE1MSIsIm5iZiI6MTc0OTAwNDI0My43NjcsInN1YiI6IjY4M2ZhZmQzN2Y5NWQzNWMzMTdiYzAyOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.zn8rynytkXOjCVRU9l4bmJe4G_QlqdtqoXIVfyolfFE"
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let homeResponse = try JSONDecoder().decode(HomeResponse.self, from: data)
            if page == 1 {
                filmes = homeResponse.results
            } else {
                filmes.append(contentsOf: homeResponse.results)
            }
            DispatchQueue.main.async {
                self.homeView.collectionView.reloadData()
                self.isPageRefreshing = false
            }
        } catch {
            print("Erro ao decodificar: \(error)")
        }
    }
    
    func viewConstraints() {
        homeView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}

//MARK: - TableView

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionViewDelegate() {
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return max(filmes.count - 1, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionView", for: indexPath) as! SectionView
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 0)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 45)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            if let firstMovie = filmes.first {
                cell.updateCell(with: firstMovie)
            }
            
            cell.onFavoriteTapped = { [weak self] in
                guard let self = self else { return }
                self.filmes[0].isFavorite.toggle()
                self.homeView.collectionView.reloadItems(at: [indexPath])
            }
            
            cell.onDetailsTapped = { [weak self] in
                var selectedMovie: MovieEntity?
                if indexPath.section == 0 {
                    selectedMovie = self?.filmes.first
                }
                guard let movie = selectedMovie else { return }
                let detailsVC = DetailsViewController()
                detailsVC.movieId = movie.id
                self?.navigationController?.pushViewController(detailsVC, animated: true)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.updateCell(with: filmes[indexPath.row + 1])
            
            cell.onFavoriteTapped = { [weak self] in
                guard let self = self else { return }
                let index = indexPath.row + 1
                self.filmes[index].isFavorite.toggle()
                self.homeView.collectionView.reloadItems(at: [indexPath])
            }
            return cell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        
        var selectedMovie: MovieEntity?
        
        if indexPath.section == 0 {
            selectedMovie = filmes.first
        } else {
            selectedMovie = filmes[indexPath.item + 1]
        }
        
        guard let movie = selectedMovie else { return }
        
        let detailsVC = DetailsViewController()
        detailsVC.movieId = movie.id
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
