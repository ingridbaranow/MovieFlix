//  HomeDataSource.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 04/06/25.

import Foundation

class HomeDataSource {
    
    let baseUrl = "https://api.themoviedb.org/3/"

    func getMovieListData(page: Int) async throws -> [MovieEntity]? {
        let endPoint = "movie/popular"
        let url = URL(string: baseUrl+endPoint)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let thePage = String(page)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: thePage),
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
            let homeResponse = try JSONDecoder().decode(HomeResponse.self, from: data)
            return homeResponse.results
        } catch {
            print("Error by decoding JSON: \(error)")
            return nil
        }
    }
    
    func searchMovie(query: String, page: Int) async throws -> [MovieEntity]? {
        let endPoint = "search/movie"
        let url = URL(string: baseUrl+endPoint)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let thePage = String(page)
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "query", value: query),
          URLQueryItem(name: "include_adult", value: "false"),
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: thePage),
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
            let homeResponse = try JSONDecoder().decode(HomeResponse.self, from: data)
            return homeResponse.results
        } catch {
            print("Error by decoding JSON: \(error)")
            return nil
        }
    }
}
