//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Addison Francisco on 5/7/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

protocol UserInfoViewControllerDelegate: class {
    func didRequestFollower(for username: String)
}

class UserInfoViewController: UIViewController {

    var username: String!
    weak var delegate: UserInfoViewControllerDelegate!

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        layoutUI()
        getUserInfo()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        _ = [headerView, itemViewTwo, itemViewOne, dateLabel].forEach { itemView in
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func add(childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }

    @objc
    private func dismissViewController() {
        dismiss(animated: true)
    }

    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    private func configureUIElements(with user: User) {
        self.add(childViewController: GFUserInfoHeaderViewController(user: user), to: self.headerView)
        self.add(childViewController: GFRepoItemViewController(user: user, delegate: self), to: self.itemViewOne)
        self.add(childViewController: GFFollowerItemViewController(user: user, delegate: self), to: self.itemViewTwo)

        self.dateLabel.text = "GitHub user since \(user.createdAt.convertToMonthYearFormat())"
    }

}

extension UserInfoViewController: GFRepoItemViewControllerDelegate {

    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "Ok")
            return
        }

        presentSafariViewController(with: url)
    }

}

extension UserInfoViewController: GFFollowerItemViewControllerDelegate {

    func didTapGetFollowers(for user: User) {
        guard user.followers > 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 😞.", buttonTitle: "So sad")
            return
        }

        delegate?.didRequestFollower(for: user.login)
        dismissViewController()
    }

}
