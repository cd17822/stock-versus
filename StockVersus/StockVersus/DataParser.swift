//
//  DataParser.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/8/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation

class DataParser {
    public static func parseAndSavePortfolio(_ data: [String: Any], _ cb: (Portfolio?, Error?) -> ()) {
        CoreDataHandler.fetchUser() { user, err in
            if err != nil {
                print(err!)
                cb(nil, err)
                return
            }

            CoreDataHandler.fetchPortfolios(belongingTo: user!) { portfolios, err in
                if err != nil {
                    print(err!)
                    cb(nil, err)
                    return
                }

                let id = data["id"] as! String
                let portfolio = portfolios?.filter({ $0.id == id }).first ?? Portfolio(context: CoreDataHandler.context)

                portfolio.id = id
                portfolio.user = user
                portfolio.time_init = Date() as NSDate
                portfolio.time_init = dateFromString(data["created_at"] as! String) as NSDate? ?? portfolio.time_init
                portfolio.name = data["name"] as? String
                portfolio.cash = data["cash"] as! Float

                portfolio.ranking_d = data["ranking_d"] as! Int32
                portfolio.ranking_w = data["ranking_w"] as! Int32
                portfolio.ranking_m = data["ranking_m"] as! Int32
                portfolio.ranking_q = data["ranking_q"] as! Int32
                portfolio.ranking_y = data["ranking_y"] as! Int32
                portfolio.ranking_a = data["ranking_a"] as! Int32

                portfolio.balance = data["balance"] as! Float
                portfolio.balance_d = data["balance_d"] as! Float
                portfolio.balance_w = data["balance_w"] as! Float
                portfolio.balance_m = data["balance_m"] as! Float
                portfolio.balance_q = data["balance_q"] as! Float
                portfolio.balance_y = data["balance_y"] as! Float

                var stocks_to_save = [Stock]()
                var stocks_to_delete = [Stock]()

                var buy_data = data["buys"] as? [[String: Any]]
                if buy_data == nil {
                    buy_data = [[String:Any]]()
                }

                if portfolio.buys != nil {
                    // for each of the saved buys
                    for buy in portfolio.buys! {
                        let b = buy as! Stock
                        let before_count = buy_data!.count
                        // if we find a match, sieve it out of the json data because we don't need to do anything with it
                        buy_data = buy_data!.filter {
                            $0["id"] as! String != b.id! &&
                            ($0["stock"] as! [String: Any])["balance"] as! Float != b.balance
                        }
                        // if we didn't sieve it out
                        if buy_data!.count == before_count {
                            // then delete it
                            stocks_to_delete.append(b)
                        }
                    }
                }

                // if there are still things left that weren't sieved out then we want to save them
                for b in buy_data! {
                    let s = Stock(context: CoreDataHandler.context)
                    s.id = b["id"] as? String
                    s.shares = b["shares"] as! Int32
                    s.balance_a = b["balance_a"] as! Float

                    let stock = b["stock"] as! [String: Any]
                    s.ticker = stock["ticker"] as? String
                    s.balance = stock["balance"] as! Float
                    s.balance_d = stock["balance_d"] as! Float
                    s.balance_w = stock["balance_w"] as! Float
                    s.balance_m = stock["balance_m"] as! Float
                    s.balance_q = stock["balance_q"] as! Float
                    s.balance_y = stock["balance_y"] as! Float


                    s.buy_portfolio = portfolio
                    s.put_portfolio = nil

                    stocks_to_save.append(s)
                }

                var put_data = data["puts"] as? [[String: Any]]
                if put_data == nil {
                    put_data = [[String:Any]]()
                }
                
                if portfolio.puts != nil {
                    for put in portfolio.puts! {
                        let p = put as! Stock
                        let before_count = put_data!.count
                        put_data = put_data!.filter {
                            $0["id"] as! String != p.id! &&
                            ($0["stock"] as! [String: Any])["balance"] as! Float != p.balance
                        }
                        if put_data!.count == before_count {
                            stocks_to_delete.append(p)
                        }
                    }
                }

                for p in put_data! {
                    let s = Stock(context: CoreDataHandler.context)
                    s.id = p["id"] as? String
                    s.shares = p["shares"] as! Int32
                    s.balance_a = p["balance_a"] as! Float

                    let stock = p["stock"] as! [String: Any]
                    s.ticker = stock["ticker"] as? String
                    s.balance = stock["balance"] as! Float
                    s.balance_d = stock["balance_d"] as! Float
                    s.balance_w = stock["balance_w"] as! Float
                    s.balance_m = stock["balance_m"] as! Float
                    s.balance_q = stock["balance_q"] as! Float
                    s.balance_y = stock["balance_y"] as! Float


                    s.buy_portfolio = nil
                    s.put_portfolio = portfolio

                    stocks_to_save.append(s)
                }

                print("stocks to delete: \(stocks_to_delete)")
                print("stocks to save: \(stocks_to_save)")
                CoreDataHandler.deleteAndSave(stocks_to_delete) { err in
                    if err != nil {
                        print(err!)
                        cb(nil, err)
                    } else {
                        cb(portfolio, nil)
                    }
                }
            }
        }
    }
}
