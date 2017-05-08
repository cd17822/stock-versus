//
//  StockVersusTests.swift
//  StockVersusTests
//
//  Created by Charlie DiGiovanna on 5/2/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import XCTest
@testable import StockVersus

class StockVersusTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // API/NETWORK TESTS
    var users = [User]()
    var portfolios = [Portfolio]()

    func postUser() {
        let name = "Charlie DiGiovanna"
        let username = "testusername@\(Date().description)"
        NetworkHandler.createUser(name: name, username: username, password: "password") { user, err in
            XCTAssert(err == nil)
            XCTAssert(user.name == name)
            XCTAssert(user.username == username)
            users.append(user)
        }
    }

    func postPorfolio() {
        let name = "testporfolio@\(Date().description)"
        NetworkHandler.createPortfolio(named: "testporfolio@\(Date().description)") { portfolio, err in
            XCTAssert(err == nil)
            XCTAssert(portfolio.name == name)
            portfolios.append(portfolio)
        }
    }
}
