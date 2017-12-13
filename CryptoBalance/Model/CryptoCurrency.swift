//
//  CryptoCurrency.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/12/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class CryptoCurrency: NSManagedObject {
    
    class func updateOrCreate(matching currency: Currency, in context: NSManagedObjectContext) throws -> CryptoCurrency {
        
        let request: NSFetchRequest<CryptoCurrency> = CryptoCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", currency.name!)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "CryptoCurrency.updateOrCreate -- database error!")
                let cryptocurrency = matches.last!
                print("do some updating here")
                return cryptocurrency
            }
        } catch {
            print(error)
            throw error
        }
        
        let cryptocurrency = CryptoCurrency(context: context)
        cryptocurrency.ask
    }
    
    func createFromCurrency(_ currency: Currency) {
        
    }
}
