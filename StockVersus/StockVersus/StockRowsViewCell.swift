//
//  StockRowsViewCell.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/4/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class StockRowsViewCell: UITableViewCell {
    @IBOutlet weak var ticker_label: UILabel!
    @IBOutlet weak var price_change_label: UILabel!
    var stock: Stock?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateLabels(for tu: TimeUnit) {
        let balances = [stock!.balance_d, stock!.balance_w, stock!.balance_m, stock!.balance_q, stock!.balance_y, stock!.balance_a]

        ticker_label.text = stock!.name
        price_change_label.text = priceChangeString(for: stock!.balance, since: balances[tu.hashValue])
    }

}
