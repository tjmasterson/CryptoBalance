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
                return cryptocurrency.updateFromCurrency(currency, into: context)
                
            }
        } catch {
            print(error)
            throw error
        }
        
        let cryptoCurrency = self.createFromCurrency(currency, into: context)
        return cryptoCurrency
    }
    
    func updateFromCurrency(_ currency: Currency, into context: NSManagedObjectContext) -> CryptoCurrency {
        self.lastTradeClosed = CryptoCurrency.roundPrice(currency.lastTradeClosed.first!)
        return self
    }
    
    class func createFromCurrency(_ currency: Currency, into context: NSManagedObjectContext) -> CryptoCurrency {
        let cryptoCurrency = CryptoCurrency(context: context)
        cryptoCurrency.name = currency.name!
        cryptoCurrency.lastTradeClosed = self.roundPrice(currency.lastTradeClosed.first!)
        return cryptoCurrency
    }
    
    class func roundPrice(_ price: String) -> Double {
        return Double(price)!.rounded()
    }
}
