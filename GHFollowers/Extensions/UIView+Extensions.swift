//
//  UIView+Extensions.swift
//  GHFollowers
//
//  Created by Addison Francisco on 5/15/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { view in
			addSubview(view)
        }
    }

    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
}
