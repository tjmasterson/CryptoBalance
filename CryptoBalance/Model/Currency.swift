//
//  Currency.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/10/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import Foundation

public struct Currency: Codable {
    let ask: [String] // ask array(<price>, <whole lot volume>, <lot volume>),
    let bid: [String] // bid array(<price>, <whole lot volume>, <lot volume>),
    let lastTradeClosed: [String] // last trade closed array(<price>, <lot volume>),
    let volume: [String] // volume array(<today>, <last 24 hours>),
    let volumeWeightedAveragePrice: [String] // volume weighted average price array(<today>, <last 24 hours>),
    let numberOfTrades: [Int] // number of trades array(<today>, <last 24 hours>),
    let low: [String] // low array(<today>, <last 24 hours>),
    let high: [String] // high array(<today>, <last 24 hours>),
    let openingPriceToday: String // today's opening price

    private enum CodingKeys: String, CodingKey {
        case ask = "a"
        case bid = "b"
        case lastTradeClosed = "c"
        case volume = "v"
        case volumeWeightedAveragePrice = "p"
        case numberOfTrades = "t"
        case low = "l"
        case high = "h"
        case openingPriceToday = "o"
    }
}
