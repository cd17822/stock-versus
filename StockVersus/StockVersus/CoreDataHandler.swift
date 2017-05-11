//
//  CoreDataHandler.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/4/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHandler {
    public static var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "StockVersus")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error: \(error)")
            }
        })
        return container.viewContext
    }()


    public static func storeUser(_ cb: (User, Error?) -> ()) {
        let user = User(context: context)
        user.id = USER_ID
        user.username = USER_USERNAME
        user.name = USER_NAME

        save { err in
            cb(user, err)
        }
    }

    public static func fetchUser(_ cb: (User?, Error?) -> ()) {
        let request = NSFetchRequest<User>(entityName: "User")

        do {
            let users = try context.fetch(request)
//            let user = users.filter { $0.username == USER_USERNAME }.first
            let user = users.first

            if user == nil {
                cb(nil, nil)
                return
            } else {
                USER_ID = user!.id!
                USER_NAME = user!.name!
                USER_USERNAME = user!.username!

                cb(user, nil)
            }
        } catch let error as NSError {
            cb(nil, error)
        }
    }

    public static func fetchPortfolios(belongingTo user: User, _ cb: ([Portfolio]?, Error?) -> ()) {
        let request = NSFetchRequest<Portfolio>(entityName: "Portfolio")

        do {
            let portfolios = try context.fetch(request)
            cb(portfolios, nil)
        } catch let error as NSError {
            cb(nil, error)
        }
    }

    public static func deleteAllPortfolios(belongingTo user: User, _ cb: (Error?) -> ()) {
        fetchPortfolios(belongingTo: user) { portfolios, err in
            if err != nil {
                cb(err)
                return
            }

            for p in portfolios! {
                context.delete(p)
            }

            save { err in
                cb(err)
            }
        }
    }

    public static func addStock(buy: Bool, ticker: String, shares: Int, to portfolio: Portfolio, _ cb: (Portfolio?, Error?) -> ()) {
        var stock: Stock? = nil

        for s in (buy ? portfolio.buys!.map({ $0 as! Stock }) : portfolio.puts!.map({ $0 as! Stock })) {
            if s.ticker == ticker {
                s.shares = Int32(shares)
                stock = s
            }
        }

        if stock == nil {
            stock = Stock(context: context)
            stock!.ticker = ticker
            stock!.shares = Int32(shares)
            stock!.buy_portfolio = buy ? portfolio : nil
            stock!.put_portfolio = buy ? nil : portfolio
        }

        save { err in
            if err != nil {
                cb(nil, err)
                return
            }

            cb(portfolio, err)
        }
    }

    public static func deleteAndSave(_ objects: [NSManagedObject], _ cb: (Error?) -> ()) {
        for o in objects {
            context.delete(o)
        }

        save { err in
            cb(err)
        }
    }

    public static func deleteEverything(_ cb: (Error?) -> ()) {
        let user_fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let user_request = NSBatchDeleteRequest(fetchRequest: user_fetch)

        let portfolio_fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Portfolio")
        let portfolio_request = NSBatchDeleteRequest(fetchRequest: portfolio_fetch)

        let stock_fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        let stock_request = NSBatchDeleteRequest(fetchRequest: stock_fetch)

        do {
            try context.execute(user_request)
            try context.execute(portfolio_request)
            try context.execute(stock_request)

            cb(nil)
        } catch let error {
            cb(error)
        }
    }

    public static func save(_ cb: (Error?) -> ()) {
        if !context.hasChanges {
            cb(nil)
            return
        }

        do {
            try self.context.save()
            cb(nil)
        } catch let error as NSError {
            cb(error)
        }
    }
}

