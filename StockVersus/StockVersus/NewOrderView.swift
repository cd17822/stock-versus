//
//  NewOrderView.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/7/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class NewOrderView: UIView {
    @IBOutlet var content_view: UIView!
    @IBOutlet weak var inner_view: UIView!
    @IBOutlet weak var buy_label: UILabel!
    @IBOutlet weak var confirm_button: UIButton!
    @IBOutlet weak var ticker_field: UITextField!
    @IBOutlet weak var shares_field: UITextField!
    @IBOutlet weak var individual_cost_label: UILabel!
    @IBOutlet weak var total_cost_label: UILabel!

    var vc: PortfolioViewController?
    var ticker_price: Float?
    var cash: Float?
    var buy: Bool?

    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.loadNib()
    }


    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.loadNib()
    }

    private func loadNib() {
        Bundle.main.loadNibNamed("NewOrderView", owner: self, options: nil)
        guard let content = content_view else { return }
        content.frame = self.bounds
        addSubview(content)

        inner_view.layer.borderWidth = 1
        inner_view.layer.borderColor = UIColor.darkGray.cgColor

        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    func checkForConfirmability() {
        confirm_button.isEnabled = shares_field.text != nil && Int(shares_field.text!) != nil && ticker_price != nil && Float(total_cost_label.text!.substring(from: total_cost_label.text!.startIndex))! <= cash!
    }

    func updatePriceLabels() {
        if ticker_price == nil || shares_field.text == nil || Int(shares_field.text!) == nil {
            individual_cost_label.text = "$0.00"
            total_cost_label.text = "$0.00"
            return
        }

        individual_cost_label.text = "$\(ticker_price!.with2DecimalPlaces)"

        total_cost_label.text = "$\((ticker_price! * Float(shares_field.text!)!).with2DecimalPlaces)"
    }

    @IBAction func tickerFieldEditingDidBegin(_ sender: Any) {
        ticker_price = nil
        confirm_button.isEnabled = false
        shares_field.text = "0"
        updatePriceLabels()
    }

    @IBAction func tickerFieldEditingDidEnd(_ sender: Any) {
        if ticker_field == nil { return }

        NetworkHandler.getPrice(of: ticker_field.text!) { tickerPrice, err in
            if err != nil || tickerPrice == nil {
                return
            }

            self.ticker_price = tickerPrice
            self.checkForConfirmability()
            self.updatePriceLabels()
        }
    }

    @IBAction func sharesFieldEditingChanged(_ sender: Any) {
        checkForConfirmability()
        updatePriceLabels()
    }


    @IBAction func confirmPressed(_ sender: Any) {
        vc!.placeOrder(buy: buy!, ticker: ticker_field.text!, shares: Int(shares_field.text!)!)
        removeFromSuperview()
    }
}
