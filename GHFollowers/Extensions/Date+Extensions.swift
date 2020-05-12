//
//  Date+Extensions.swift
//  GHFollowers
//
//  Created by Addison Francisco on 5/11/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
		let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"

        return dateFormatter.string(from: self)
    }

}
