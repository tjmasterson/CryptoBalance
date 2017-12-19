//
//  AccountsViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit
import CoreData

class AccountsViewController: UIViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<Account>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateUI() {
        
    }

}
