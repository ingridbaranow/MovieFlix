//  HomeViewModel.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 04/06/25.

import Foundation

private let homeDataSource = HomeDataSource()

class HomeViewModel {
    
    var page: Int = 1
    var popularMovies: [MovieEntity] = []
    var searchedMovies: [MovieEntity] = []
    var isSearching: Bool = false
    
    func getMovieListData() async throws -> Void {
        guard let movies = try await homeDataSource.getMovieListData(page: page) else {return}
        if page > 1 {
            popularMovies.append(contentsOf: movies)
            return
        }
        popularMovies = movies
    }
    
    func searchMovie(query: String) async throws -> Void {
        guard let movies = try await homeDataSource.searchMovie(query: query, page: page) else {return}
        if page > 1 {
            searchedMovies.append(contentsOf: movies)
            return
        }
        searchedMovies = movies
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
