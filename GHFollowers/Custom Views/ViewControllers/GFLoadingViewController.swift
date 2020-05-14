//
//  GFLoadingViewController.swift
//  GHFollowers
//
//  Created by Addison Francisco on 5/14/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

class GFLoadingViewController: UIViewController {

    var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0

        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        activityIndicator.startAnimating()
    }

    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }

}
