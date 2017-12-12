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
        let nestedContainer = try container.nestedContainer(keyedBy: CurrencyKey.self, forKey: .result)
        self.error = try container.decode([String].self, forKey: .error)
        for key in nestedContainer.allKeys {
            self.currency = try nestedContainer.decode(Currency.self, forKey: .makeKey(name: key.stringValue))
        }
    }
    
    private struct CurrencyKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let error = CurrencyKey(stringValue: "error")!
        static let result = CurrencyKey(stringValue: "result")!
        static func makeKey(name: String) -> CurrencyKey {
            return CurrencyKey(stringValue: name)!
        }
    }
}




