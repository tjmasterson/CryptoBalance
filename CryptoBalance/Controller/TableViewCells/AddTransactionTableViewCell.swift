//
//  AddTransactionTableViewCell.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/28/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit


class AddTransactionTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var cellType: AddTransactionCell? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        titleLabel?.text = cellType!.sectionTitle()
        valueTextField?.delegate = self
        valueTextField?.keyboardType = cellType!.keyboardType()
        addToolbarInputAccessoryView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func addToolbarInputAccessoryView() {
        let toolbar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.saveButtonClicked))
        
        toolbar.sizeToFit()
        toolbar.setItems([flexibleSpace, saveButton, flexibleSpace], animated: false)
        toolbar.isTranslucent = false
        toolbar.barTintColor = .green
        valueTextField?.inputAccessoryView = toolbar
    }
    
    @objc func saveButtonClicked() {
        valueTextField?.resignFirstResponder()
    }
}
