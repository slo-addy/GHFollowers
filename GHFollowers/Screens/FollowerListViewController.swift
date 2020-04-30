//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Addison Francisco on 2/20/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

class FollowerListViewController: UIViewController {

    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result {
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
            case .success(let followers):
                print("Followers count = \(followers.count)")
                print(followers)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
