//
//  PricesViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit
import CoreData

class PricesViewController: FetchedResultsTableViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet {
            updateUI()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<CryptoCurrency>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshController()
        fetchAllCurrencies()
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupRefreshController() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
        } else {
            tableView.addSubview(UIRefreshControl())
        }
        
        tableView.refreshControl?.addTarget(self, action: #selector(refreshCurrencyData(_:)), for: .valueChanged)
        tableView.refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Currencies ...")
    }
    
    @objc private func refreshCurrencyData(_ sender: Any) {
        fetchAllCurrencies()
    }
    
    private func fetchAllCurrencies() {
        let request = Request.init(.all)
        request.fetchAllCurrencies { [weak self] (results, error) in
            DispatchQueue.main.async {
                if let currencies = results {
                    self?.updateDatabase(with: currencies as! [Currency])
                } else {
                    print(error)
                }
            }
        }
    }
    
    private func updateDatabase(with currencies: [Currency]) {
        let context = container?.viewContext
        for currency in currencies {
            let _ = try? CryptoCurrency.updateOrCreate(matching: currency, in: context!)
        }
        try? context!.save()
        printDatabaseStatistics()
        updateUI()
        self.refreshControl?.endRefreshing()
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
        }
    }

}

extension PricesViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PricesTableViewCell", for: indexPath) as? PricesTableViewCell else {
            fatalError("Not able to deque table view cell")
        }
        
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        cell.cyrptoCurrency = object
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections!.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections, sections.count > 0 else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
}
