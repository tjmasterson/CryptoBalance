//
//  CurrencyItem.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import Foundation

public struct CurrencyItem: Decodable {
    
    let a: [String] // ask array(<price>, <whole lot volume>, <lot volume>),
    let b: [String] // bid array(<price>, <whole lot volume>, <lot volume>),
    let c: [String] // last trade closed array(<price>, <lot volume>),
    let v: [String] // volume array(<today>, <last 24 hours>),
    let p: [String] // volume weighted average price array(<today>, <last 24 hours>),
    let t: [String] // number of trades array(<today>, <last 24 hours>),
    let l: [String] // low array(<today>, <last 24 hours>),
    let h: [String] // high array(<today>, <last 24 hours>),
    let o: String // today's opening price
    
    
    enum CodingKeys: String, CodingKey {
        case a = "ask" // ask array(<price>, <whole lot volume>, <lot volume>),
        case b = "bid" // bid array(<price>, <whole lot volume>, <lot volume>),
        case c = "lastTradClosed" // last trade closed array(<price>, <lot volume>),
        case v = "volume" // volume array(<today>, <last 24 hours>),
        case p = "volumeWeightedAveragePrice" // volume weighted average price array(<today>, <last 24 hours>),
        case t = "numberOfTrades" // number of trades array(<today>, <last 24 hours>),
        case l = "low" // low array(<today>, <last 24 hours>),
        case h = "high" // high array(<today>, <last 24 hours>),
        case o = "openingPriceToday" // today's opening price
    }
}
