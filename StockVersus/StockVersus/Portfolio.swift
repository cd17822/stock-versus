//
//  Portfolio.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/4/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation
import CoreData

class Portfolio: NSManagedObject {
    @NSManaged var buys: [NSString]
    @NSManaged var puts: [NSString]
}
