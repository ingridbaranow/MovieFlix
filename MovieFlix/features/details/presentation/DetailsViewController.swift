//
//  DetailsViewController.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 05/06/25.
//

import UIKit
import SnapKit

class DetailsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let detailsView = DetailsView()
    var details: DetailsEntity?
    var movieId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundDark
        view.addSubview(scrollView)
        scrollView.addSubview(detailsView)
        viewConstraints()
        favoriteStatus()
        Task {
            do {
                try await getMovieDetailsData(id: movieId)
            } catch {
                print("Error: \(error)")
            }
        }
        
    }
    
    func viewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        detailsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    func getMovieDetailsData(id: Int) async throws -> Void {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/"+String(id))!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
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
            let detailsEntity = try JSONDecoder().decode(DetailsEntity.self, from: data)
            details = detailsEntity
            detailsView.detailsContentView.updateView(with: detailsEntity)
            detailsView.imageHeaderView.updateView(with: detailsEntity)
            
        } catch {
            print("Erro ao decodificar: \(error)")
        }
    }
    
    func favoriteStatus() {
        detailsView.imageHeaderView.onFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            details?.isFavorite.toggle()
            if let isFavorite = details?.isFavorite {
            detailsView.imageHeaderView.updateFavorite(with: isFavorite)
            }
        }
    }
}
