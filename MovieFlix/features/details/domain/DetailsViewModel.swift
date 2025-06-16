//  DetailsViewModel.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 09/06/25.

import Foundation

class DetailsViewModel {
    
    private let detailsDataSource = DetailsDataSource()
    var details: DetailsEntity?
    
    func getMovieDetailsData(id: Int?) async throws -> Void {
        if let id = id {
            details = try await detailsDataSource.getMovieDetailsData(id: id)
        } else {
            print("Error: ID is nil. Not possible to get movie details.")
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
