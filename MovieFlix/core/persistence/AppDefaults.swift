//  AppDefaults.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 10/06/25.

import Foundation

class AppDefaults {
    
    static var currentFavoriteList: [Int] = []
    
    static func addFavorite(id: Int) {
        UserDefaults.standard.set(true, forKey: "FavoritedId: \(id)")
        
        var currentFavoriteList = UserDefaults.standard.array(forKey: "ListOfIds") as? [Int] ?? []
        if !currentFavoriteList.contains(id) {
            currentFavoriteList.append(id)
            UserDefaults.standard.set(currentFavoriteList, forKey: "ListOfIds")
            print("IDs salvos: \(currentFavoriteList)")
        }
    }
    
    static func removeFavorite(id: Int) {
        UserDefaults.standard.set(false, forKey: "FavoritedId: \(id)")
        
        var currentFavoriteList = UserDefaults.standard.array(forKey: "ListOfIds") as? [Int] ?? []
        currentFavoriteList.removeAll { $0 == id }
        UserDefaults.standard.set(currentFavoriteList, forKey: "ListOfIds")
        print("Lista: \(currentFavoriteList)")
    }
    
    static func isAlredyFavorited(id: Int) -> Bool {
        return UserDefaults.standard.bool(forKey: "FavoritedId: \(id)")
    }
    
    static func getAllFavorites() -> [Int] {
        let currentFavoriteList = UserDefaults.standard.array(forKey: "ListOfIds") as? [Int] ?? []
        return currentFavoriteList
    }
}


