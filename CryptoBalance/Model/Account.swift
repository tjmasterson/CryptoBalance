//
//  Account.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class Account: NSManagedObject {
    
    class func create(with cryptoCurrency: CryptoCurrency, in context: NSManagedObjectContext) throws -> Account {
        do {
            let account = Account(context: context)
            account.name = cryptoCurrency.name
            account.currencyValue = cryptoCurrency.lastTradeClosed
            return account
        } catch {
            print(error)
            throw error
        }
    }
    
    func calculateAmountOwned() -> Double {
        var total: Double = 0
        if let transactions = self.transactions {
            for transaction in transactions {
                let t = transaction as? Transaction
                total += (t?.currencyAmount)!
            }
        }
        return total
    }
    
    func calculateDollarValue() -> Double {
        return self.calculateAmountOwned() * self.cryptocurrency!.lastTradeClosed
    }
}
