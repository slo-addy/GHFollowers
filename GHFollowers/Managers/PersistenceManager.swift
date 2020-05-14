//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Addison Francisco on 5/12/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add
    case remove
}

enum PersistenceManager {

    enum Keys {
        static let favorites = "favorites"
    }

    static private let defaults = UserDefaults.standard

    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrieveFavorites = favorites

                switch actionType {
                case .add:
                    guard !retrieveFavorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }

                    retrieveFavorites.append(favorite)
                case .remove:
                    retrieveFavorites.removeAll { $0.login == favorite.login }
                }

                completion(save(favorites: retrieveFavorites))
            case .failure(let error):
                completion(error)
            }
        }
    }

    static func retrieveFavorites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }

        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        }
        catch {
            completion(.failure(.unableToFavorite))
        }
    }

    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)

            return nil
        }
        catch {
            return .unableToFavorite
        }
    }

}
