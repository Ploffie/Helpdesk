//
//  alertMessageViewController.swift
//  helpDesk
//
//  Created by Wybren Oppedijk on 25-02-16.
//  Copyright © 2016 Amerion IT. All rights reserved.
//

import UIKit

public class alertMessageViewController: UIViewController {

    @IBOutlet public weak var navigationBar: UINavigationItem!
    @IBOutlet var messageText: UITextView!
    
    private let defaultData = NSUserDefaults.standardUserDefaults()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let title = self.defaultData.valueForKey(dataMessages)![self.defaultData.integerForKey(dataMessageToDisplay)].valueForKey(responseTitle) as? String
        let message = self.defaultData.valueForKey(dataMessages)![self.defaultData.integerForKey(dataMessageToDisplay)].valueForKey(responseMessage) as? String
        navigationBar.title = title
        messageText.text = message
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
