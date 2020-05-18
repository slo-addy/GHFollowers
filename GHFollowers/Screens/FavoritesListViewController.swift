//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by Addison Francisco on 2/14/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

class FavoritesListViewController: UIViewController {

	let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureTableView() {
        view.addSubview(tableView)
        showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: view)

        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseID)
        tableView.removeExcessCells()
    }

    private func getFavorites() {
        PersistenceManager.shared.retrieveFavorites { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let favorites):
                self.updateUIWith(favorites: favorites)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    private func updateUIWith(favorites: [Follower]) {
        if favorites.isEmpty {
            self.tableView.isHidden = true
        }
        else {
            self.favorites = favorites

            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }

}

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseID) as! FavoriteTableViewCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationViewController = FollowerListViewController(username: favorite.login)

        navigationController?.pushViewController(destinationViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }

        PersistenceManager.shared.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else {
                return
            }

            guard let error = error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)

                if self.favorites.isEmpty {
                    tableView.isHidden = true
                }
                return
            }

            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
