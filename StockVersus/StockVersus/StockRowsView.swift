//
//  StockRowsView.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/4/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class StockRowsView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table_view: UITableView!

    var stocks = [Stock]()
    var mode = TimeUnit.day
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func numberOfSections(in tableView: UITableView) -> Int {
        print("not even getting here right")
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockRowsViewCell", for: indexPath) as! StockRowsViewCell
        cell.stock = stocks[indexPath.row]


        cell.updateLabels(for: mode)

        return cell
    }

    func updateCells(for tu: TimeUnit) {
        mode = tu
        for cell in table_view.visibleCells {
            if let c = cell as? StockRowsViewCell {
                c.updateLabels(for: mode)
            }
        }
    }
}
