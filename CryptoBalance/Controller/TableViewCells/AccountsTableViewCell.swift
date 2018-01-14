//
//  AccountsTableViewCell.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/13/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit

class AccountsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyAmountLabel: UILabel!
    @IBOutlet weak var accountDollarValue: UILabel!
    
    var account: Account? {
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
        currencyLabel?.text = account?.name
        currencyAmountLabel?.text = String(describing: (account?.calculateAmountOwned())!)
        accountDollarValue?.text = currencyFormatter((account?.calculateDollarValue())!)
    }
    
}
