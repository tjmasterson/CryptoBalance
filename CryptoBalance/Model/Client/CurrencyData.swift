//
//  CurrencyData.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import Foundation

public struct CurrencyData: Codable {

    var currency: Currency?
    let error: [String]
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CurrencyKey.self)
        
        self.error = try container.decode([String].self, forKey: .error)
        
        let nestedContainer = try container.nestedContainer(keyedBy: CurrencyKey.self, forKey: .result)
        for key in nestedContainer.allKeys {
            self.currency = try nestedContainer.decode(Currency.self, forKey: .makeKey(name: key.stringValue))
        }
        
    }
    
    struct CurrencyKey: CodingKey {
        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { return nil }

        var intValue: Int? { return nil }
        var stringValue: String

        static let result = CurrencyKey(stringValue: "result")!
        static let error = CurrencyKey(stringValue: "error")!

        static func makeKey(name: String) -> CurrencyKey {
            return CurrencyKey(stringValue: name)!
        }
    }
}




