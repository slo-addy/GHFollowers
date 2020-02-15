//
//  GFButton.swift
//  GHFollowers
//
//  Created by Addison Francisco on 2/14/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
    }
}
