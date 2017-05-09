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

                if let portfolio_data = data["portfolio"] as? [String: Any] {
                    let id = portfolio_data["id"] as! String
                    let portfolio = portfolios.filter({ $0.id == id }).first ?? Portfolio(context: CoreDataHandler.context)

                    portfolio.id = id
                    portfolio.user = user
                    portfolio.time_init = dateFromString(portfolio_data["created_at"] as! String) as NSDate
                    portfolio.name = portfolio_data["name"] as? String
                    portfolio.cash = portfolio_data["cash"] as! Float

                    portfolio.ranking = portfolio_data["ranking"] as! Int32
                    portfolio.ranking_d = portfolio_data["ranking_d"] as! Int32
                    portfolio.ranking_w = portfolio_data["ranking_w"] as! Int32
                    portfolio.ranking_m = portfolio_data["ranking_m"] as! Int32
                    portfolio.ranking_q = portfolio_data["ranking_q"] as! Int32
                    portfolio.ranking_y = portfolio_data["ranking_y"] as! Int32
                    portfolio.ranking_a = portfolio_data["ranking_a"] as! Int32

                    portfolio.balance = portfolio_data["balance"] as! Float
                    portfolio.balance_d = portfolio_data["balance_d"] as! Float
                    portfolio.balance_w = portfolio_data["balance_w"] as! Float
                    portfolio.balance_m = portfolio_data["balance_m"] as! Float
                    portfolio.balance_q = portfolio_data["balance_q"] as! Float
                    portfolio.balance_y = portfolio_data["balance_y"] as! Float

                    var stocks_to_save = [Stock]()
                    var stocks_to_delete = [Stock]()

                    var buy_data = portfolio_data["buys"] as? [[String: Any]]
                    if buy_data == nil {
                        buy_data = [[String:Any]]()
                    }

                    if portfolio.buys != nil {
                        for buy in portfolio.buys! {
                            let b = buy as! Stock
                            let before_count = buy_data!.count
                            buy_data = buy_data!.filter { ($0["ticker"] as! String) != b.ticker! }
                            if before_count == buy_data!.count {
                                stocks_to_delete.append(b)
                            }
                        }
                    }

                    for b in buy_data! {
                        let s = Stock(context: CoreDataHandler.context)
                        s.ticker = b["ticker"] as? String
                        s.shares = b["shares"] as! Int32
                        s.balance = b["balance"] as! Float
                        s.balance_d = b["balance_d"] as! Float
                        s.balance_w = b["balance_w"] as! Float
                        s.balance_m = b["balance_m"] as! Float
                        s.balance_q = b["balance_q"] as! Float
                        s.balance_y = b["balance_y"] as! Float
                        s.balance_a = b["balance_a"] as! Float

                        s.buy_portfolio = portfolio
                        s.put_portfolio = nil
                        
                        stocks_to_save.append(s)
                    }
                    
                    var put_data = portfolio_data["puts"] as? [[String: Any]]
                    if put_data == nil {
                        put_data = [[String:Any]]()
                    }

                    if portfolio.puts != nil {
                        for put in portfolio.puts! {
                            let p = put as! Stock
                            let before_count = put_data!.count
                            put_data = put_data!.filter { ($0["ticker"] as! String) != p.ticker! }
                            if before_count == put_data!.count {
                                stocks_to_delete.append(p)
                            }
                        }
                    }

                    for p in put_data! {
                        let s = Stock(context: CoreDataHandler.context)
                        s.ticker = p["ticker"] as? String
                        s.shares = p["shares"] as! Int32
                        s.balance = p["balance"] as! Float
                        s.balance_d = p["balance_d"] as! Float
                        s.balance_w = p["balance_w"] as! Float
                        s.balance_m = p["balance_m"] as! Float
                        s.balance_q = p["balance_q"] as! Float
                        s.balance_y = p["balance_y"] as! Float
                        s.balance_a = p["balance_a"] as! Float
                        
                        s.buy_portfolio = nil
                        s.put_portfolio = portfolio
                        
                        stocks_to_save.append(s)
                    }
                    
                    CoreDataHandler.delete(stocks_to_delete)

                    CoreDataHandler.save { err in
                        if err != nil {
                            print(err!)
                            cb(nil, err)
                        }

                        cb(portfolio, nil)
                    }
                }
            }
        }
    }
}
