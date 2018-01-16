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
    
    @IBAction func valueTextFieldChanged(_ sender: UITextField) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TextFieldDidUpdate"), object: self, userInfo: ["indexPath": self.indexPath!])
    }
    
    var cellType: AddTransactionCell? {
        didSet {
            updateUI()
        }
    }
    
    var indexPath: Int?
    
    func updateUI() {
        titleLabel?.text = cellType!.sectionTitle()
        valueTextField?.delegate = self
        if let keyBoardType = cellType?.keyboardType() {
            valueTextField?.keyboardType = keyBoardType
        } else {
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            valueTextField?.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        valueTextField?.text = dateFormatter.string(from: sender.date)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TextFieldDidUpdate"), object: self, userInfo: ["indexPath": self.indexPath!])

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
        valueTextField?.reloadInputViews()
    }
    
    @objc func saveButtonClicked() {
        valueTextField?.resignFirstResponder()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SaveTransaction"), object: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
