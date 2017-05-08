//
//  Global.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/2/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation

let USER = "cd17822" // gotta change
let NUM_PORTFOLIOS: Int32 = 100 // fake
let PORTFOLIO_START_VALUE: Float = 100000.00

enum TimeUnit {
    case day, week, month, quarter, year, alltime
}

func rankPercentString(for ranking: Int32) -> String {
    let rp = (Float(ranking) - 0.5) / Float(NUM_PORTFOLIOS)
    let nearest5 = Int(rp * 100 / 20) + 1
    let nearest10 = Int(rp * 100 / 10) + 1

    var return_string: String
    if nearest5 == 1 && nearest10 == 1 {
        return_string = "Top \(Int(rp*100) + 1)%"
    } else if nearest10 <= 6 {
        return_string = "Top \(nearest10)0%"
    } else {
        return_string = "Bottom \(11-nearest10)0%"
    }

    return return_string
}

func dollarChangeString(for balance: Float, since balanceOld: Float) -> String {
    let pm = balance >= balanceOld ? "+" : "-"

    return pm + "$" + abs(balance - balanceOld).with2DecimalPlaces
}

func percentChangeString(for balance: Float, since balanceOld: Float, withoutPlusMinus: Bool=false) -> String {
    let pm = balance >= balanceOld && !withoutPlusMinus ? "+" : ""

    return pm + (balance/balanceOld).with2DecimalPlaces + "%"
}

func priceChangeString(for balance: Float, since balanceOld: Float) -> String {
    return "\(dollarChangeString(for: balance, since: balanceOld)) (\(percentChangeString(for: balance, since: balanceOld, withoutPlusMinus: true)))"
}

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
