//
//  PricesViewController.swift
//  CryptoBalance
//
//  Created by Taylor Masterson on 12/9/17.
//  Copyright © 2017 Taylor Masterson. All rights reserved.
//

import UIKit

class PricesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = Request.init(.bitcoin)
        request.fetch { (results, err) in
            print("I'm done")
        }
    }
}