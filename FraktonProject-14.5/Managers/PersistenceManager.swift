//
//  PersistenceManager.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 21.9.21.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum Keys {
    static let favorites = "favorites"
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    static func updateWith(favorite: User, actionType: PersistenceActionType, completed: @escaping (DBError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.id == favorite.id }
                }
                
                completed(save(favorites: favorites))
                
            case.failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveFavorites(completed: @escaping (Result<[User], DBError>) -> Void) {
        
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([User].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    
    static func save(favorites: [User]) -> DBError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
