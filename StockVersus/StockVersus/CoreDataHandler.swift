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
//
//    public static var default_level_1: Level {
//        let level = Level(context: persistentContainer.viewContext)
//        level.number = 1
//        level.best = 0
//        level.isCurrent = true
//        return level
//    }
//

    public static func fetchPortfolios(belongingTo username: String, _ cb: ([Portfolio], Error?) -> ()) {
        let request = NSFetchRequest<Portfolio>(entityName: "Portfolio")

        do {
            let portfolios = try context.fetch(request)
            cb(portfolios, nil)
        } catch let error as NSError {
            cb([], error)
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
    public static func save(_ cb: (Error?) -> ()) {
        do {
            try self.context.save()
            cb(nil)
        } catch let error as NSError {
            cb(error)
        }
    }
}

