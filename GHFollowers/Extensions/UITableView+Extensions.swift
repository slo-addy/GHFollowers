//
//  UITableView+Extensions.swift
//  GHFollowers
//
//  Created by Addison Francisco on 5/15/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import UIKit

extension UITableView {

    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }

    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
}
