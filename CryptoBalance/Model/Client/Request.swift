//
//  Request.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit
import Foundation

public class Request: NSObject {
    
    public let session = URLSession.shared
    public let requestType: RequestType
    
    public enum RequestType {
        case isAlive
        case bitcoin
    }
    
    public init(_ requestType: RequestType) {
        self.requestType = requestType
    }
    
    public func fetch(_ handler: @escaping (Any?, NSError?) -> Void) {
        let isAliveRequest = self.requestType == .isAlive
        let pathExtension = isAliveRequest ? KrakenKey.RequestType.Time : KrakenKey.RequestType.Ticker
        let url = urlWithParameters(withPathExtension: pathExtension)
        let request = requestWithHeaders(url, method: "GET")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
  
            guard self.responseInSuccessRange(response, task: "fetch", handler: handler) else {
                return
            }
            guard let data = self.dataFromResponse(data, task: "fetch", handler: handler) else {
                return
            }

            if isAliveRequest {
                return handler(nil, nil)
            }
            
            do {
                let currencyItem = try JSONDecoder().decode(CurrencyData.self, from: data)
                return handler(currencyItems, nil)
            } catch {
                print("error")
            }
            
        }
        task.resume()
    }

    private func parametersForRequest() -> [String: String]? {
        switch self.requestType {
        case .isAlive:
            return nil
        case .bitcoin:
            return [KrakenKey.queryPair: substituteKeyInString(KrakenKey.pair, key: "currencyCode", value: KrakenKey.bitcoinCurrencyCode)!]
        }
    }
    
    private func urlWithParameters(withPathExtension: String) -> URL {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = RequestConstants.APIScheme
        urlComponents.host = KrakenConstants.APIHost
        urlComponents.path = KrakenConstants.APIPath + withPathExtension

        if let parameters = parametersForRequest() {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems!.append(queryItem)
            }
        }

        return urlComponents.url!
    }
    
//    let currencyItems = JSONDecoder().decode(CurrencyItem.self, from: jsonData)
//
    private func sendError(_ errorString: String, task: String, handler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let userInfo = [NSLocalizedDescriptionKey: errorString]
        handler(nil, NSError(domain: task, code: 1, userInfo: userInfo))
    }
    
    private func responseInSuccessRange(_ response: URLResponse?, task: String, handler: (_ result: AnyObject?, _ error: NSError?) -> Void) -> Bool {
        let successRange: Range<Int> = 200..<300
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange ~= statusCode else {
            self.sendError("There was an erro with the request, returned status code outside of success range", task: task, handler: handler)
            return false
        }
        return true
    }
    
    private func requestWithHeaders(_ url: URL, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method

        return request
    }
    
    // substitute the key for the value that is contained within the method name
    private func substituteKeyInString(_ queryString: String, key: String, value: String) -> String? {
        if queryString.range(of: "{\(key)}") != nil {
            return queryString.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    private func dataFromResponse(_ data: Data?, task: String, handler: (_ result: AnyObject?, _ error: NSError?) -> Void) -> Data? {
        guard data != nil else {
            sendError("There was no data returned by request", task: task, handler: handler)
            return nil
        }
        return data
    }
    
    private struct RequestConstants {
        static let APIScheme = "https"
    }
    
    private struct KrakenConstants {
        static let APIHost = "api.kraken.com"
        static let APIPath = "/0/public/"
    }
    
    struct KrakenKey {
        static let queryPair = "pair"
        static let pair = "X{currencyCode}ZUSD"
        static let bitcoinCurrencyCode = "XBT"
        static let ethereumCurrencyCode = "ETH"
        static let litecoinCurrencyCode = "LTC"
        static let dashCurrencyCode = "DASH"
        static let zCashCurrencyCode = "ZEC"
        static let moneroCurrencyCode = "XMR"
        struct RequestType {
            static let Ticker = "Ticker"
            static let Time = "Time"
        }
        struct SearchMetaData {
            static let error = "error"
            static let results = "results"
            static let pairResults = "results.X{currencyCode}ZUSD"
        }
    }
}
