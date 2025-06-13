//  DetailsEntity.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 05/06/25.

import Foundation

struct DetailsEntity: Codable {
    let id: Int
    let title: String
    let tagline: String
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String
    let runtime: Int
    let overview: String
    let status: String
    let originalLanguage: String
    let budget: Int
    let revenue: Int
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case tagline
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case runtime
        case overview
        case status
        case originalLanguage = "original_language"
        case budget
        case revenue
        case posterPath = "poster_path"
    }
}
