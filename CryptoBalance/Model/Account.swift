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
}
