//
//  Tests.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/8/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation

class Tests {
    public static func performAll() {
        testPostUser()
        testPostPorfolio()
        testPutOrder()
    }

    public static func testPostUser() {
        let name = "Charlie DiGiovanna"
        let username = "testusername@\(Date().description)"
        NetworkHandler.createUser(name: name, username: username, password: "password") { user, err in
            print("testPostUser")
            print(err ?? "no error")
            print(user ?? "nil user")
        }
    }

    public static func testPostPorfolio() {
        let name = "testporfolio@\(Date().description)"
        NetworkHandler.createPortfolio(named: name) { portfolio, err in
            print("testPostPortfolio")
            print(err ?? "no error")
            print(portfolio ?? "nil portfolio")
        }
    }

    public static func testPutOrder() {
        CoreDataHandler.fetchUser() { user, err in
            CoreDataHandler.fetchPortfolios(belongingTo: user!) { portfolios, err in
                NetworkHandler.createOrder(buy: true, ticker: "AAPL", shares: 10, portfolio: portfolios.first!) { portfolio, err in
                    print("testPostOrder")
                    print(err ?? "no error")
                    print(portfolio ?? "nil portfolio")
                }
            }
        }

    }
}
