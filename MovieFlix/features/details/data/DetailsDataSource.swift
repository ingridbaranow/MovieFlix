//  DetailsDataSource.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 09/06/25.

import Foundation

class DetailsDataSource {
    
    let baseUrl = "https://api.themoviedb.org/3/movie/"
    
    func getMovieDetailsData(id: Int) async throws -> DetailsEntity? {
        let endPoint = String(id)
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
            print("error: API Token not found")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(DetailsEntity.self, from: data)
        } catch {
            print("Erro ao decodificar: \(error)")
            return nil
        }
    }
}

