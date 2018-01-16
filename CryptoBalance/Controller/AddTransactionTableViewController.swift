//
//  AddTransactionTableViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 1/7/18.
//  Copyright © 2018 Taylor Masterson. All rights reserved.
//

import UIKit
import CoreData

class AddTransactionTableViewController: UITableViewController, UITextFieldDelegate {
    
    var container: NSPersistentContainer? // = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var account: Account?
    
    lazy var numberOfTableViewRows: Int = tableView.numberOfRows(inSection: 0)
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "TextFieldDidUpdate"), object: nil, queue: nil, using: shouldPresentSaveButton(_:))
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "SaveTransaction"), object: nil, queue: nil, using: saveTransaction(_:))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "TextFieldDidUpdate"), object: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddTransactionCell.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addTransactionCell = AddTransactionCell(rawValue: indexPath.item) else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTransactionTableViewCell", for: indexPath) as! AddTransactionTableViewCell
        cell.cellType = addTransactionCell
        cell.indexPath = indexPath.item
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let addTransactionCell = AddTransactionCell(rawValue: indexPath.item)!
        let cell = tableView.cellForRow(at: indexPath)  as! AddTransactionTableViewCell
        cell.valueTextField?.becomeFirstResponder()
    }
    
    private func shouldPresentSaveButton(_ notification: Notification) -> Void  {
        var cellsWithValuesCount = 0
        if numberOfTableViewRows > 0 {
            for row in 0..<numberOfTableViewRows {
                if cellHasValueAt(rowIndex: row) {
                    cellsWithValuesCount += 1
                }
            }
        }
        if cellsWithValuesCount == numberOfTableViewRows {
            presentSaveButton(notification.userInfo as! [String: Int])
        }
    }
    
    private func cellHasValueAt(rowIndex: Int) -> Bool {
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! AddTransactionTableViewCell
        return cell.valueTextField?.hasText ?? false
    }
    
    private func presentSaveButton(_ userInfo: [String: Int]) {
        if let indexOfFirstResponder = userInfo["indexPath"] {
            let indexPath = IndexPath(row: indexOfFirstResponder, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! AddTransactionTableViewCell
            cell.addToolbarInputAccessoryView()
        }
    }
    
    private func saveTransaction(_ notification: Notification) -> Void {
        if let context = container?.viewContext {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM dd, yyyy"
            let transaction = Transaction(context: context)
            for row in 0..<numberOfTableViewRows {
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.cellForRow(at: indexPath) as! AddTransactionTableViewCell
                let type = cell.cellType!
                switch (type) {
                case .boughtAtPrice:
                    transaction.boughtAtPrice = Double((cell.valueTextField?.text)!)!
                case .currencyAmount:
                    transaction.currencyAmount = Double((cell.valueTextField?.text)!)!
                case .date:
                    transaction.date = dateFormatter.date(from:(cell.valueTextField?.text)!)!
                case .dollarsSpent:
                    transaction.dollarsSpent = Double((cell.valueTextField?.text)!)!
                }
            }
            
            account?.addToTransactions(transaction)
            do {
                try context.save()
            } catch {
                print(error)   
            }
            dismiss(animated: true, completion: nil)
        }
    }

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
    
    func keyboardType() -> UIKeyboardType? {
        switch self {
        case .boughtAtPrice, .currencyAmount, .dollarsSpent:
            return UIKeyboardType.numberPad
        case .date:
            return nil
        }
    }
    
}

