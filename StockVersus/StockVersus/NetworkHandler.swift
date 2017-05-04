//
//  NetworkHandler.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/2/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation

class NetworkHandler {
    private static func simulateGetPortfolios(belongingTo username: String, _ cb: ([Portfolio], Error?) -> ()) {
        let aapl = Stock(context: CoreDataHandler.context)
        aapl.ticker = "AAPL"
        aapl.name = "Apple, Inc."
        aapl.balance = 133.44
        aapl.balance_d = 133.19
        aapl.balance_w = 130.90
        aapl.balance_m = 121.41
        aapl.balance_q = 120.01
        aapl.balance_y = 111.31
        aapl.balance_a = 100.44

        let msft = Stock(context: CoreDataHandler.context)
        msft.ticker = "MSFT"
        msft.name = "Miscrosoft, Inc."
        msft.balance = 133.44
        msft.balance_d = 133.19
        msft.balance_w = 130.90
        msft.balance_m = 121.41
        msft.balance_q = 120.01
        msft.balance_y = 111.31
        msft.balance_a = 100.44

        let p1 = Portfolio(context: CoreDataHandler.context)
        p1.name = "iPad > Surface"
        p1.time_init = NSDate()
        p1.user = User(context: CoreDataHandler.context)
        p1.user!.username = username
        p1.balance = 11133.44
        p1.balance_d = 11133.19
        p1.balance_w = 11130.90
        p1.balance_m = 11121.41
        p1.balance_q = 11120.01
        p1.balance_y = 10111.31
        p1.ranking_d = 1
        p1.ranking_w = 50
        p1.ranking_m = 51
        p1.ranking_q = 60
        p1.ranking_y = 100
        p1.ranking_a = 7
        p1.addToBuys(aapl)
        p1.addToPuts(msft)

        CoreDataHandler.save { err in
            CoreDataHandler.fetchPortfolios(belongingTo: USER) { portfolios, err in
                cb(portfolios, err)
            }
        }
    }

    public static func getPortfolios(belongingTo username: String, _ cb: ([Portfolio], Error?) -> ()) {
        // MISSING IMPLEMENTATION
        simulateGetPortfolios(belongingTo: username, cb)
    }
}
