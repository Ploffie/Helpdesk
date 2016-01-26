//
//  alertViewFunction.swift
//  helpDesk
//
//  Created by Wybren Oppedijk on 08-01-16.
//  Copyright © 2016 Amerion IT. All rights reserved.
//

import Foundation

public class alertViewFunction {
    
    public func create(title: String, message: String) -> UIViewController {
        let alertView:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertView.addAction(OKAction)
        return alertView
    }
}