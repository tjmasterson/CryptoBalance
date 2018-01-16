//
//  ErrorNotificationViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 1/16/18.
//  Copyright © 2018 Taylor Masterson. All rights reserved.
//

import UIKit

class ErrorNotificationViewController: UIViewController {
    
    func notify(_ presenter: UIViewController?, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        presenter?.present(alert, animated: true, completion: nil)
    }
    
    func log(_ message: Any) {
        debugPrint("Major Error: \(message)")
    }
}

extension ErrorNotificationViewController {
    
    class func sharedInstance() -> ErrorNotificationViewController {
        struct Singleton {
            static var sharedInstance = ErrorNotificationViewController()
        }
        return Singleton.sharedInstance
    }
}
