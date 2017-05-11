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
    var plus: Bool?

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
        if plus! {
            confirm_button.isEnabled = shares_field.text != nil && shares_field.text != "" && Int(shares_field.text!) != nil && ticker_price != nil && Float(shares_field.text!) != nil && Float(ticker_price! * Float(shares_field.text!)!) <= cash!
        } else {
            if ticker_field.text == nil || shares_field.text == nil || Int32(shares_field.text!) == nil {
                confirm_button.isEnabled = false
            } else {
                if buy! {
                    if let _ = vc!.portfolio!.buys!.filter({ ($0 as! Stock).ticker! == ticker_field.text! && ($0 as! Stock).shares >= Int32(shares_field.text!)! }).first {
                        confirm_button.isEnabled = true
                    }
                } else {
                    if let _ = vc!.portfolio!.puts!.filter({ ($0 as! Stock).ticker! == ticker_field.text! && ($0 as! Stock).shares >= Int32(shares_field.text!)! }).first {
                        confirm_button.isEnabled = true
                    }
                }
            }
        }
    }

    func updatePriceLabels() {
        DispatchQueue.main.async() {
            if self.ticker_price == nil || self.shares_field.text == nil || Int(self.shares_field.text!) == nil {
                self.total_cost_label.text = "$0.00"
                return
            }

            if self.shares_field.text != nil && self.shares_field.text! == "0"
            {
                self.shares_field.text = ""
            }
            self.individual_cost_label.text = self.ticker_price!.dollarString

            self.total_cost_label.text = (self.ticker_price! * Float(self.shares_field.text!)!).dollarString
        }
    }

    @IBAction func tickerFieldEditingDidBegin(_ sender: Any) {
        ticker_price = nil
        confirm_button.isEnabled = false
        shares_field.text = "0"
        individual_cost_label.text = "$0.00"
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
        let shares_multiplier = plus! ? 1 : -1
        vc!.placeOrder(buy: buy!, ticker: ticker_field.text!, shares: shares_multiplier * Int(shares_field.text!)!)
    }

    public func initLabels() {
        if buy! {
            if plus! {
                buy_label.text = "BUY"
            } else {
                buy_label.text = "SELL"
            }
        } else {
            if plus! {
                buy_label.text = "SHORT"
            } else {
                buy_label.text = "SELL SHORT"
            }
        }
    }
}
