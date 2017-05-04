//
//  FeedTableViewCell.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/4/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var pane_canvas_view: UIView!
    var portfolio: Portfolio?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillCanvas() {
        let pane_view = FeedPaneView()
        pane_view.portfolio = portfolio
        pane_view.drawLabels()
        pane_view.frame = pane_canvas_view.bounds
        pane_canvas_view.addSubview(pane_view)
    }

}
