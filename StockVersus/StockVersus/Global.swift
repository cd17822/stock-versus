//
//  Global.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/2/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation

//var USER: User {
//    let u = User()
//    u.name = "Charlie DiGiovanna"
//    u.username = "cd17822"
//    return u
//}

var USER_ID = "3427892378425302349"
var USER_NAME = "Charlie DiGiovanna"
var USER_USERNAME  = "cd17822"

let NUM_PORTFOLIOS: Int32 = 100 // fake
let PORTFOLIO_START_VALUE: Float = 100000.00

#if (arch(i386) || arch(x86_64)) && os(iOS) // if running on simulator, route to localhost
let API_URL = "http://localhost:3939"
let TESTING = true
#else                                       // otherwise, route to CharlieD.me server
let API_URL = "http://104.131.167.230:3939"
let TESTING = false
#endif

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

func dollarChangeString(for balance: Float, since balanceOld: Float, times: Float = 1) -> String {
    let pm = balance >= balanceOld ? "+" : "-"

    return pm + "$" + abs(Float(times) * (balance - balanceOld)).with2DecimalPlaces
}

func percentChangeString(for balance: Float, since balanceOld: Float, withoutPlusMinus: Bool=false) -> String {
//    let pm = balance >= balanceOld && !withoutPlusMinus ? "+" : ""

    return (100 * (balance/balanceOld - 1)).with2DecimalPlaces + "%"
}

func priceChangeString(for balance: Float, since balanceOld: Float, times: Float = 1) -> String {
    return "\(dollarChangeString(for: balance, since: balanceOld, times: times)) (\(percentChangeString(for: balance, since: balanceOld, withoutPlusMinus: true)))"
}

func dateFromString(_ dateString: String) -> Date {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZ"

    var date = dateFormatter.date(from: dateString)

    if (date == nil) {
        print("ERROR:", "Could not parse date: \(dateString). Using NOW as date")
        date = Date()
    }

    return date!
}

func stringFromDate(_ date: Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZ"

    return dateFormatter.string(from: date)
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
        let pre = self < 1 && self > -1 ? "" : ""

        return pre + fmt.string(from: NSNumber(value: self))! // ?? self.description
    }
}
