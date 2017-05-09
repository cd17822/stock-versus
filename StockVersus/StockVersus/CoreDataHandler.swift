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
            let user = users.filter { $0.username == USER_USERNAME }.first
            if user == nil {
                cb(user, nil)
            } else {
                storeUser { user, err in
                    if err != nil {
                        print(err!)
                        return
                    }
                    cb(user, err)
                }
            }
        } catch let error as NSError {
            cb(nil, error)
        }
    }

    public static func fetchPortfolios(belongingTo user: User, _ cb: ([Portfolio], Error?) -> ()) {
        let request = NSFetchRequest<Portfolio>(entityName: "Portfolio")

        do {
            let portfolios = try context.fetch(request)
            cb(portfolios, nil)
        } catch let error as NSError {
            cb([], error)
        }
    }

    public static func deleteAllPortfolios(belongingTo user: User, _ cb: (Error?) -> ()) {
        fetchPortfolios(belongingTo: user) { portfolios, err in
            if err != nil {
                cb(err)
                return
            }

            for p in portfolios {
                context.delete(p)
            }

            save { err in
                cb(err)
            }
        }
    }

//    private static func fetchLevels(_ callback: ((_ levels: [Level], _ error: NSError?) -> Void)) {
//        let request = NSFetchRequest<Level>(entityName: "Level")
//        do {
//            let levels = try persistentContainer.viewContext.fetch(request)
//            callback(levels, nil)
//        } catch let error as NSError {
//            callback([], error)
//        }
//    }
//
//    public static func getCurrentLevel(_ callback: @escaping ((_ level: Level, _ error: NSError?) -> Void)) {
//        fetchLevels { levels, error in
//            if error != nil {
//                callback(self.default_level_1, error)
//            }else{
//                print("calling conv init")
//                var current_level = self.default_level_1
//                print("called")
//                for level in levels {
//                    if level.isCurrent {
//                        current_level = level
//                        print("got something")
//                        break
//                    }
//                }
//                print("got nothin")
//                callback(current_level, nil)
//            }
//        }
//    }
//
//    public static func makeCurrentLevel(_ number: Int16, _ callback: ((_ error: NSError?) -> Void)) {
//        print("makecurrentlevel")
//        print(number)
//        fetchLevels { levels, error in
//            if error != nil {
//                callback(error)
//            } else {
//                let level_to_save = Level(context: persistentContainer.viewContext)
//                level_to_save.number = number
//
//
//                for level in levels {
//                    if level.number == number {
//                        level_to_save.best = level.best
//                    }
//                    level.isCurrent = false
//                }
//
//                level_to_save.isCurrent = true
//                print("LEVEL TO SAVE")
//                print(level_to_save)
//                do {
//                    try persistentContainer.viewContext.save()
//                    callback(nil)
//                } catch let error as NSError {
//                    callback(error)
//                }
//            }
//        }
//    }
//
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

            print("PORTFOLIO")
            print(portfolio)
            cb(portfolio, err)
        }
    }

    public static func delete(_ objects: [NSManagedObject]) {
        for o in objects {
            context.delete(o)
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

