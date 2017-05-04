//
//  Global.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/2/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation

let USER = "cd17822"

extension Date {
    var prettyButShortDateTimeDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter.string(from: self).components(separatedBy: " at ").joined(separator: " ")
    }

    var prettyDateTimeDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short

        return formatter.string(from: self).components(separatedBy: " at ").joined(separator: " ")
    }

    var prettyDateDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long

        return formatter.string(from: self)
    }

    var prettyTimeDescription: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short

        return formatter.string(from: self)
    }
}

extension Float {
    var with2DecimalPlaces: String {
        let fmt = NumberFormatter()
        fmt.maximumFractionDigits = 2
        fmt.minimumFractionDigits = 2
        let pre = self < 1 && self > -1 ? "0" : ""

        return pre + fmt.string(from: NSNumber(value: self))! // ?? self.description
    }
}
