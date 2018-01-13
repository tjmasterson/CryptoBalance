//
//  TransactionsTableViewCell.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/28/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dollarsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var transaction: Transaction? {
        didSet {
            updateUI()
        }
    }
    
    private func currencyFormatter(_ price: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = NSLocale.current
        let currency = currencyFormatter.string(for: price)
        return currency!
    }
    
    private func updateUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        amountLabel?.text = String(describing: (transaction?.currencyAmount)!)
        priceLabel?.text = currencyFormatter((transaction?.boughtAtPrice)!)
        dollarsLabel?.text = currencyFormatter((transaction?.dollarsSpent)!)
        dateLabel?.text = dateFormatter.string(from: (transaction?.date)!)
        
    }
}
