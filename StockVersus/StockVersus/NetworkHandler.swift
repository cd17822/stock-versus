//
//  NetworkHandler.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/2/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation

class NetworkHandler {
    private static func simulateGetPortfolios(belongingTo user: User, _ cb: ([Portfolio], Error?) -> ()) {
        CoreDataHandler.deleteAllPortfolios(belongingTo: user) { err in
            if err != nil {
                cb([], err)
                return
            }

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
            aapl.shares = 178

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
            msft.shares = 10

            let p1 = Portfolio(context: CoreDataHandler.context)
            p1.name = "iPad > Surface"
            p1.time_init = NSDate()
            p1.user = User(context: CoreDataHandler.context)
            p1.user!.username = user.username!
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
    }

    private static func post(_ endpoint: String, _ data: [String:String], _ cb: (Data?, Error?) -> ()) {
        var request = URLRequest(url: URL(string: "\(API_URL)\(endpoint)")!)
        request.httpMethod = "POST"

        // let postString = data.reduce("?") { $0.key + "=" + $0.value + "&" + $1.key + "=" + $1.value } // lol xcode doesn't like this
        var post_string = "?"
        for d in data {
            post_string += "\(d.key)=\(d.value)&"
        }
        post_string.remove(at: post_string.endIndex) // remove trailing &
        request.httpBody = post_string.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(error!)")
                return
            }

            print("RAWDATA: \(data)")

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 { // check for http errors
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }



            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
        }
        
        task.resume()
    }

    public static func getPortfolios(belongingTo user: User, _ cb: ([Portfolio], Error?) -> ()) {
        // MISSING IMPLEMENTATION
        simulateGetPortfolios(belongingTo: user, cb)
    }

    public static func getPrice(of ticker: String, _ cb: (Float?, Error?) -> ()) {
        // MISSING IMPLEMENTATION
        cb(50.00, nil)
    }

    public static func createUser(name: String, username: String, password: String, _ cb: (User, Error?) -> ()) {

    }

    public static func createPortfolio(named name: String, _ cb: (Portfolio, Error?) -> ()) {
        post("/portfolios", ["name": name, "username": USER.username!, "balance": "\(PORTFOLIO_START_VALUE)", "cash": "\(PORTFOLIO_START_VALUE)"]) { data, err in
            if err != nil {
                print("Error creating portfolio: \(err!)")
                return
            }
            print("GOTTEN DATA: \(data!)")
        }
    }
}
