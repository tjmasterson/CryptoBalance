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
    
    public enum RequestType: String {
        case all
        case isAlive
        case bitcoin
        case ethereum
        case liteCoin
        case dash
        case zCash
        case monero
        static let allCurrencyRequestTypes = [bitcoin, ethereum, liteCoin, dash, zCash, monero]
    }
    
    public init(_ requestType: RequestType) {
        self.requestType = requestType
    }
    
//    func whatThread(_ whereAmI: String) {
//        if Thread.isMainThread {
//            print(whereAmI, "on main thread")
//        } else {
//            print(whereAmI, "off main thread")
//        }
//    }
    
    public func fetchAllCurrencies(_ handler: @escaping(Any?, NSError?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var resultingData: [Currency] = []
        for currency in RequestType.allCurrencyRequestTypes {
            dispatchGroup.enter()
            fetch(currency) { (results, error) in
                if results != nil {
                    resultingData.append(results as! Currency)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            if resultingData.isEmpty {
                self.sendError("Kraken servers seems to be working, but there is no data for any currencies.", task: "fetchAllCurrecies", handler: handler)
            } else {
                handler(resultingData, nil)
            }
            
        }
    }
    
    public func fetch(_ requestType: RequestType? = nil, _ handler: @escaping (Any?, NSError?) -> Void) {

        let pathExtension = buildPathExtension()
        let parameters = parametersForRequestType(requestType ?? self.requestType)
        let url = buildURL(withPathExtension: pathExtension, andParameters: parameters)
        let request = requestWithHeaders(url, method: "GET")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard self.responseInSuccessRange(response, task: "fetch", handler: handler) else {
                return
            }
            guard let data = self.dataFromResponse(data, task: "fetch", handler: handler) else {
                return
            }

            if self.requestType == .isAlive {
                return handler(nil, nil)
            }

            do {
                let currencyData = try JSONDecoder().decode(CurrencyData.self, from: data)
                var currency = currencyData.currency!
                currency.name = requestType?.rawValue
                return handler(currency, nil)
            } catch {
                self.sendError("There was an error parsing the currency request, likely because of an update from Kraken",
                               task: "fetch",
                               handler: handler)
            }
        }
        task.resume()
    }
    
    private func buildPathExtension() -> String {
        return self.requestType == .isAlive ? KrakenKey.RequestType.Time : KrakenKey.RequestType.Ticker
    }

    private func parametersForRequestType(_ requestType: RequestType) -> [String: String]? {
        
        if self.requestType == .isAlive {
            return nil // return nil is request is checking for Kraken server status
        }
        
        var currencyCode: KrakenKey.CurrencyCodes.Currencies {
            switch requestType {
            case .bitcoin:
                return .bitcoin
            case .ethereum:
                return .ethereum
            case .liteCoin:
                return .liteCoin
            case .dash:
                return .dash
            case .zCash:
                return .zCash
            case .monero:
                return .monero
            default:
                return .bitcoin
            }
        }
        
        let queryPair = substituteKeyInString(KrakenKey.pair, key: "currencyCode", value: currencyCode.rawValue)!
        return [KrakenKey.queryPair: queryPair]
    }
    
    private func buildURL(withPathExtension: String, andParameters parameters: [String: String]?) -> URL {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = RequestConstants.APIScheme
        urlComponents.host = KrakenConstants.APIHost
        urlComponents.path = KrakenConstants.APIPath + withPathExtension

        if let parameters = parameters {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems!.append(queryItem)
            }
        }

        return urlComponents.url!
    }
    
    private func sendError(_ errorString: String, task: String, handler: (_ result: Any?, _ error: NSError?) -> Void) {
        let userInfo = [NSLocalizedDescriptionKey: errorString]
        handler(nil, NSError(domain: task, code: 1, userInfo: userInfo))
    }
    
    private func responseInSuccessRange(_ response: URLResponse?, task: String, handler: (_ result: Any?, _ error: NSError?) -> Void) -> Bool {
        let successRange: Range<Int> = 200..<300
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange ~= statusCode else {
            self.sendError("There was an error with the request, returned status code outside of success range", task: task, handler: handler)
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
    
    private func dataFromResponse(_ data: Data?, task: String, handler: (_ result: Any?, _ error: NSError?) -> Void) -> Data? {
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
        struct CurrencyCodes {
            enum Currencies: String {
                case bitcoin = "XBT"
                case ethereum = "ETH"
                case liteCoin = "LTC"
                case dash = "DASH"
                case zCash = "ZEC"
                case monero = "XMR"
                static let allValues = [bitcoin, ethereum, liteCoin, dash, zCash, monero]
            }
        }
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
