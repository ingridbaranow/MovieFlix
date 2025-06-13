//  HomeEntity.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 04/06/25.

import Foundation

struct HomeResponse: Codable {
    let results: [MovieEntity]
}

struct MovieEntity: Codable {
    let id: Int
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
