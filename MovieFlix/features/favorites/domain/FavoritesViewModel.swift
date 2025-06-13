//  FavoritesViewModel.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 13/06/25.

import Foundation

class FavoritesViewModel {
    
    private let favoritesDataSource = FavoritesDataSource()
    var favorites: [FavoritesEntity] = []
    
    func getFavoritesListData() async throws -> Void {
        favorites = []
        let ids = AppDefaults.getAllFavorites()
        
        for id in ids {
            if let movie = try? await favoritesDataSource.getFavoritesListData(id: id) {
                favorites.append(movie)
            } else {
                print("error")
            }
        }
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

