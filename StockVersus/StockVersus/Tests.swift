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
    }

    public static func testPostUser() {
        let name = "Charlie DiGiovanna"
        let username = "testusername@\(Date().description)"
        NetworkHandler.createUser(name: name, username: username, password: "password") { user, err in
            print("callingback")
            assert(err == nil)
            assert(user!.name == name)
            assert(user!.username == username)
        }
        print("last")
    }

    public static func testPostPorfolio() {
        let name = "testporfolio@\(Date().description)"
        NetworkHandler.createPortfolio(named: "testporfolio@\(Date().description)") { portfolio, err in
            print("callingback")
            assert(err == nil)
            assert(portfolio.name == name)
            assert(portfolio.user?.name == USER_NAME)
            assert(portfolio.user?.username == USER_USERNAME)
        }
        print("last")
    }
}
