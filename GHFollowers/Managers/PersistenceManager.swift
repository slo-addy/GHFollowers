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

class PersistenceManager {

    enum Keys {
        static let favorites = "favorites"
    }

    static let shared = PersistenceManager()
    private let defaults = UserDefaults.standard

    private init() {}

    func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }

                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }

                completion(self.save(favorites: favorites))
            case .failure(let error):
                completion(error)
            }
        }
    }

    func retrieveFavorites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
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

    func save(favorites: [Follower]) -> GFError? {
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
