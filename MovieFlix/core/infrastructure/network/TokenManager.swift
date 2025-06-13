//  TokenManager.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 13/06/25.

import Foundation

enum TokenManager {
    static func getToken() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dictionary = NSDictionary(contentsOfFile: path),
           let key = dictionary["TMDB_API_TOKEN"] as? String {
            return key
        }
        return nil
    }
}


