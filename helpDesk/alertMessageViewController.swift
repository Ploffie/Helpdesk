//
//  homeViewController.swift
//  helpDesk
//
//  Created by Thuis on 04-11-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import UIKit

class allertMessageViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet var alertMessagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    // TODO: Array w/ items that go in table view, changing relatively
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
