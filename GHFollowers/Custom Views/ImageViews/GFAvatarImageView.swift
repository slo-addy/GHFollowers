//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Addison Francisco on 4/29/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = Images.placeholder
        translatesAutoresizingMaskIntoConstraints = false
    }

}
