//
//  AddTransactionTableViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 1/7/18.
//  Copyright © 2018 Taylor Masterson. All rights reserved.
//

import UIKit

class AddTransactionTableViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UIGestureRecognizer(target: self, action: #selector(self.view.endEditing(_:))) // HERE
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddTransactionCell.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addTransactionCell = AddTransactionCell(rawValue: indexPath.item) else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTransactionTableViewCell", for: indexPath) as! AddTransactionTableViewCell
        cell.cellType = addTransactionCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let addTransactionCell = AddTransactionCell(rawValue: indexPath.item)!

        let cell = tableView.cellForRow(at: indexPath)  as! AddTransactionTableViewCell
        cell.valueTextField?.becomeFirstResponder()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(indexPath)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return indexPath
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}

enum AddTransactionCell: Int {
    case boughtAtPrice, currencyAmount, date, dollarsSpent
    
    static var count = {
        return AddTransactionCell.sectionTitles.count
    }
    
    static let sectionTitles = [
        boughtAtPrice: "Currency Price",
        currencyAmount: "Amount Of Currency",
        date: "Date",
        dollarsSpent: "Dollars Spent"
    ]
    
    func sectionTitle() -> String {
        if let sectionTitle = AddTransactionCell.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
    
    func keyboardType() -> UIKeyboardType {
        switch self {
        case .boughtAtPrice, .currencyAmount, .dollarsSpent:
            return UIKeyboardType.numberPad
        default:
            return UIKeyboardType.default
        }
    }
    
}

