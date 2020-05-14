//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Addison Francisco on 2/20/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

protocol FollowerListViewControllerDelegate: class {
    func didRequestFollower(for username: String)
}

class FollowerListViewController: GFLoadingViewController {

    enum Section {
        case main
    }

    var username: String
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false

    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
        self.title = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

		configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView,
                                                                           cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)

            return cell
        })
    }

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }

    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {
                return
            }
            self.dismissLoadingView()

            switch result {
            case .success(let followers):
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers)

                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers."
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    @objc
    func addButtonTapped() {
        showLoadingView()

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {
                return
            }

            self.dismissLoadingView()

            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else {
                        return
                    }

                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user 🎉.", buttonTitle: "Ok")
                        return
                    }

                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]

        let destinationViewController = UserInfoViewController()
        destinationViewController.username = follower.login
        destinationViewController.delegate = self

        let navigationController = UINavigationController(rootViewController: destinationViewController)
        present(navigationController, animated: true)
    }

}

extension FollowerListViewController: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {
                return
            }
            page += 1
            getFollowers(username: username, page: page)
        }
    }

}

extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            return
        }
		isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		isSearching = false
        updateData(on: followers)
    }

}

extension FollowerListViewController: FollowerListViewControllerDelegate {

    func didRequestFollower(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }

}
