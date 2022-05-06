//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Jerry Turcios on 10/23/20.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"

        return dateFormatter.string(from: self)
    }
}
