//
//  PricesViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit
import CoreData

class PricesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<CryptoCurrency>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    private func fetchAllCurrencies() {
        let request = Request.init(.all)
        request.fetchAllCurrencies { [weak self] (results, error) in
            DispatchQueue.main.async {
                if let currencies = results {
                    self?.updateDatabase(with: currencies as! [Currency])
                }
            }
        }
    }
    
    private func updateDatabase(with currencies: [Currency]) {
        container?.performBackgroundTask { [weak self] context in
            for currency in currencies {
                _ = try? CryptoCurrency.updateOrCreate(matching: currency, in: context)
            }
            try? context.save()
            print("done updating the database")
        }
    }
    
    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<CryptoCurrency> = CryptoCurrency.fetchRequest()
            request.predicate = NSPredicate(format: "all")
            fetchedResultsController = NSFetchedResultsController<CryptoCurrency>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }
}

extension PricesViewController: NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
}


