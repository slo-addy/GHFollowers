//
//  GFRepoItemViewController.swift
//  GHFollowers
//
//  Created by Addison Francisco on 5/11/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

protocol GFRepoItemViewControllerDelegate: class {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemViewController: GFItemInfoViewController {

    weak var delegate: GFRepoItemViewControllerDelegate!

    init(user: User, delegate: GFRepoItemViewControllerDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }

    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }

}
