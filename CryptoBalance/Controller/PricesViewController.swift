//
//  PricesViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit
import CoreData

class PricesViewController: UIViewController, NSFetchedResultsControllerDelegate  {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet {
            print("here?")
            updateUI()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<CryptoCurrency>? {
        didSet {
            fetchedResultsController?.delegate = self
            self.tableView?.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllCurrencies()
        updateUI()
        
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
//        container?.performBackgroundTask { [weak self] context in
        let context = container?.viewContext
        for currency in currencies {
            let _ = try? CryptoCurrency.updateOrCreate(matching: currency, in: context!)
        }
        try? context!.save()
        printDatabaseStatistics()
//        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                if let currencyCount = try? context.count(for: CryptoCurrency.fetchRequest()) {
                    print("\(currencyCount) CryproCurrencies")
                }
            }
        }
    }
    
    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<CryptoCurrency> = CryptoCurrency.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(
                key: "name",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController<CryptoCurrency>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
            print("calling update UI")
        }
    }

}

extension PricesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func buildValues(for cell: PricesTableViewCell, with fetchedObject: CryptoCurrency) -> PricesTableViewCell {
        cell.assetTotalValueLabel.text = String(fetchedObject.lastTradeClosed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PricesTableViewCell", for: indexPath) as? PricesTableViewCell else {
            fatalError("Not able to deque table view cell")
        }
        
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        return buildValues(for: cell, with: object)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections, sections.count > 0 else {
//            fatalError("No sections in fetchedResultsController")
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
}

extension PricesViewController {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}



