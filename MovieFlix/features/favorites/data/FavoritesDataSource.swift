//  FavoritesDataSource.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 13/06/25.

import Foundation

class FavoritesDataSource {
    
    let baseUrl = "https://api.themoviedb.org/3/"
    
    func getFavoritesListData(id: Int) async throws -> FavoritesEntity? {
        let endPoint = "movie/"+String(id)
        let url = URL(string: baseUrl+endPoint)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        if let apiToken = TokenManager.getToken() {
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "Authorization": apiToken
            ]
        } else {
            print("Error: API Token not found")
        }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(FavoritesEntity.self, from: data)
        } catch {
            print("Error by decoding JSON: \(error)")
            return nil
        }
    }
}

