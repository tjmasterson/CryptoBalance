//
//  PricesTableViewCell.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/13/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit


class PricesTableViewCell: UITableViewCell {
    
    // Keys on the left hand side of cell
    @IBOutlet weak var currencyKeyLabel: UILabel!
    @IBOutlet weak var amountOwnedKeyLabel: UILabel!
    @IBOutlet weak var assetTotalKeyLabel: UILabel!
    @IBOutlet weak var dollarsInvestedKeyLabel: UILabel!
    
    // Values on the right hand side of cell matching to key labels
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var amountOwnedValueLabel: UILabel!
    @IBOutlet weak var assetTotalValueLabel: UILabel!
    @IBOutlet weak var dollarsInvestedValueLabel: UILabel!
    
    var cyrptoCurrency: CryptoCurrency? {
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
        currencyKeyLabel?.text = cyrptoCurrency?.name!
        currencyValueLabel?.text = currencyFormatter((cyrptoCurrency?.lastTradeClosed)!)
        amountOwnedValueLabel?.text = currencyFormatter((cyrptoCurrency?.account?.currencyAmount)!)
        assetTotalValueLabel?.text = currencyFormatter((cyrptoCurrency?.account?.valueInDollars)!)
        dollarsInvestedValueLabel?.text = currencyFormatter((cyrptoCurrency?.account?.dollarsInvested)!)
    }
    

}
