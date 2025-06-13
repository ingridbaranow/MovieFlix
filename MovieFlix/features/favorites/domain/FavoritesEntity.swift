//  FavoritesEntity.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 12/06/25.

import Foundation

struct FavoritesEntity: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
