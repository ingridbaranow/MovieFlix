//  HomeDataSource.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 04/06/25.

import Foundation

class HomeDataSource {
    
    let baseUrl = "https://api.themoviedb.org/3/movie/"

    func getMovieListData(page: Int) async throws -> [MovieEntity]? {
        let endPoint = "popular"
        let url = URL(string: baseUrl+endPoint)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let mypage = String(page)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: mypage),
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
            let homeResponse = try JSONDecoder().decode(HomeResponse.self, from: data)
            return homeResponse.results
        } catch {
            print("Erro ao decodificar: \(error)")
            return nil
        }
    }
}
