//
//  PricesViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit
import CoreData

class PricesViewController: UIViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<CryptoCurrency>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllCurrencies()
        
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
                let _ = try? CryptoCurrency.updateOrCreate(matching: currency, in: context)
            }
            try? context.save()
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

//override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) else {
//        fatalError("Wrong cell type dequeued")
//    }
//    // Set up the cell
//    guard let object = self.fetchedResultsController?.object(at: indexPath) else {
//        fatalError("Attempt to configure cell without a managed object")
//    }
//    //Populate the cell from the object
//    return cell
//}
//
//
//override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    guard let sections = fetchedResultsController.sections else {
//        fatalError("No sections in fetchedResultsController")
//    }
//    let sectionInfo = sections[section]
//    return sectionInfo.numberOfObjects
//}

extension PricesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PricesTableViewCell", for: indexPath) as! PricesTableViewCell else {
            fatalError("Not able to deque table view cell")
        }
        
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
}

extension PricesViewController: NSFetchedResultsControllerDelegate {
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



