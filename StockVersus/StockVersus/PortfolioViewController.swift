//
//  PortfolioViewController.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/2/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class PortfolioViewController: UIViewController {
    @IBOutlet weak var balance_label: UILabel!
    @IBOutlet weak var change_label: UILabel!
    @IBOutlet weak var d_button: UIButton!
    @IBOutlet weak var w_button: UIButton!
    @IBOutlet weak var m_button: UIButton!
    @IBOutlet weak var q_button: UIButton!
    @IBOutlet weak var y_button: UIButton!
    @IBOutlet weak var a_button: UIButton!
    var time_unit_buttons: [UIButton] {
        return [d_button, w_button, m_button, q_button, y_button, a_button]
    }
    @IBOutlet weak var underline_view: UIView!
    @IBOutlet weak var buys_canvas: UIView!
    @IBOutlet weak var puts_canvas: UIView!
    @IBOutlet weak var cash_label: UILabel!

    var portfolio: Portfolio?
    let buys_table = StockRowsView()
    let puts_table = StockRowsView()
    var stock_tables: [StockRowsView] {
        return [buys_table, puts_table]
    }
    var mode = TimeUnit.day

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "bg"))
        setLabels()
    }

    override func viewDidAppear(_ animated: Bool) {
        addTablesToCanvases()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setLabels() {
        let balances = [portfolio!.balance_d, portfolio!.balance_w, portfolio!.balance_m, portfolio!.balance_q, portfolio!.balance_y, PORTFOLIO_START_VALUE]

        balance_label.text = "$\(portfolio!.balance.with2DecimalPlaces)"
        change_label.text = priceChangeString(for: portfolio!.balance, since: balances[mode.hashValue])
    }

    func addTablesToCanvases() {
        buys_table.stocks = portfolio!.buys!.map { $0 as! Stock }
        buys_table.frame = buys_canvas.bounds
        buys_table.title_label.text = "BUYS"
        buys_table.vc = self
        buys_canvas.addSubview(buys_table)

        puts_table.stocks = portfolio!.puts!.map { $0 as! Stock }
        puts_table.frame = puts_canvas.bounds
        puts_table.title_label.text = "PUTS"
        puts_table.vc = self
        puts_canvas.addSubview(puts_table)
    }

    func timeUnitPressed() {
        moveUnderline()
        for t in stock_tables {
            t.updateCells(for: mode)
        }
    }

    @IBAction func dPressed(_ sender: Any) {
        mode = .day
        timeUnitPressed()
    }

    @IBAction func wPressed(_ sender: Any) {
        mode = .week
        timeUnitPressed()
    }

    @IBAction func mPressed(_ sender: Any) {
        mode = .month
        timeUnitPressed()
    }

    @IBAction func qPressed(_ sender: Any) {
        mode = .quarter
        timeUnitPressed()
    }

    @IBAction func yPressed(_ sender: Any) {
        mode = .year
        timeUnitPressed()
    }

    @IBAction func aPressed(_ sender: Any) {
        mode = .alltime
        timeUnitPressed()
    }

    func moveUnderline() {
        UIView.animate(withDuration: 0.25, animations: {
            self.underline_view.frame = self.underline_view.frame.offsetBy(dx: 5 + self.time_unit_buttons[self.mode.hashValue].frame.minX - self.underline_view.frame.minX , dy: 0)
        })
    }

    public func presentNewOrderView() {
        for sv in view.subviews { // dim errything
            sv.alpha = 0.6
        }

        let new_order_view = NewOrderView()
        new_order_view.vc = self
        view.addSubview(new_order_view)
        let w: CGFloat = 220
        let h: CGFloat = 220
        new_order_view.frame = CGRect(x: view.frame.width/2-w/2, y: view.frame.height/2-h/2, width: w, height: h)
    }

    public func placeOrder(ticker: String, shares: Int) {
        print("placeOrder")

        for sv in view.subviews { // dim errything
            sv.alpha = 1
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
