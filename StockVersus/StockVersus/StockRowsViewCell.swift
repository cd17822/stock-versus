//
//  StockRowsViewCell.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/4/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class StockRowsViewCell: UITableViewCell {
    @IBOutlet weak var content_view: UIView!
    @IBOutlet weak var ticker_label: UILabel!
    @IBOutlet weak var price_change_label: UILabel!
    var stock: Stock?
    var balances: [Float] {
        return [stock!.balance_d, stock!.balance_w, stock!.balance_m, stock!.balance_q, stock!.balance_y, stock!.balance_a]
    }
    var mode: TimeUnit?
    var buy: Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTickerLabel() {
        if stock?.ticker == nil {
            return
        }

        ticker_label.text = "\(stock!.ticker!) (x\(stock!.shares))"
    }

    func setPriceChangeLabel(for tu: TimeUnit) {
        mode = tu

        price_change_label.text = priceChangeString(for: stock!.balance, since: balances[mode!.hashValue], times: Float(stock!.shares))
        price_change_label.textColor = changeColor(for: stock!.balance, since: balances[mode!.hashValue], opposite: !buy!)
    }

}
