//  HomeViewModel.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 04/06/25.

import Foundation

private let homeDataSource = HomeDataSource()

class HomeViewModel {
    
    var page: Int = 1
    var filmes: [MovieEntity] = []
    var filme: MovieEntity?
    
    func getMovieListData() async throws -> Void {
        guard let movies = try await homeDataSource.getMovieListData(page: page) else {return}
        if page > 1 {
            filmes.append(contentsOf: movies)
            return
        }
        filmes = movies
    }
    
    func incrementPage() {
        page += 1
    }
    
    func isFavorite(id: Int?) -> Bool {
        if let id = id {
            return AppDefaults.isAlredyFavorited(id: id)
        }
        return false
    }
    
    func toggleFavorite(id: Int?) {
        guard let id = id  else { return }
        isFavorite(id: id) ? AppDefaults.removeFavorite(id: id) : AppDefaults.addFavorite(id: id)
    }
}
