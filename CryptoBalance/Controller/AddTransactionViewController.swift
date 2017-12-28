//
//  AddTransactionViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/28/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit
import CoreData

class AddTransactionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension AddTransactionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddTransactionSection.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellIndex = AddTransactionSection(rawValue: indexPath.item) else { return UITableViewCell() }
        
        switch cellIndex {
        case .boughtAtPrice:
//            return (tableView.dequeueReusableCell(withIdentifier: "AddTransactionTableViewCell", for: indexPath) as? AddTransactionTableViewCell)!
            return cellForBoughtAtPriceForRowAtIndexPath(tableView, indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func cellForBoughtAtPriceForRowAtIndexPath(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTransactionTableViewCell", for: indexPath) as! AddTransactionTableViewCell
        cell.titleLabel = AddTransactionSection.sectionTitle(indexPath.item)

        return cell
    }

}

enum AddTransactionSection: Int {
    case boughtAtPrice, currencyAmount, date, dollarsSpent
    
    static var count = {
        return AddTransactionSection.sectionTitles.count
    }
    
    static let sectionTitles = [
        boughtAtPrice: "Currency Price",
        currencyAmount: "Amount Of Currency",
        date: "Date",
        dollarsSpent: "Dollars Spent"
    ]
    
    func sectionTitle() -> String {
        if let sectionTitle = AddTransactionSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
    
}
