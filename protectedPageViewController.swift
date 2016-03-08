//
//  newsViewController.swift
//  helpDesk
//
//  Created by Thuis on 04-11-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import UIKit
import Alamofire

public class protectedPageViewController: UIViewController {
    
    // All programmed
   
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var userNameLabel: UILabel!
    
    let Alert = alertViewFunction()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // MARK
        Alamofire.request(.POST, messageURL, parameters:
            [requestCompany:defaultData.valueForKey(dataCompany)!,
            requestUser: defaultData.valueForKey(dataUser)!,
            requestOccupation: defaultData.valueForKey(dataOccupation)!,
            requestSystem: defaultData.valueForKey(dataSystem)!])
            .responseJSON { responseMessage in switch responseMessage.result {
            case .Success(let JSON):
                let response = JSON as! NSDictionary
                let responseMessageList = response.valueForKey(responseMessages)!
                defaultData.setValue(responseMessageList, forKey: dataMessages)
                defaultData.synchronize()
                break
            case .Failure(_):
                print("failure")
                print("----------")
                print(responseMessage.debugDescription)
                break
            }
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.userNameLabel.text = ("Welkom, \(defaultData.valueForKey(dataUsername) as! String)!")
    }
    
    @IBAction func signOutTapped(sender: UIButton) {
        handleLogout()
    }
    
    
    
    @IBAction func changePasswordButtonTapped(sender: AnyObject) {
        self.presentViewController(Alert.create(changePasswordTitle, message: changePasswordMessage), animated: true, completion: nil)
    }

    public func handleLogout() -> Void {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        deleteData()
        return
    }
    
}


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/
