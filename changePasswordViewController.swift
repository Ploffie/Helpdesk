//
//  changePasswordViewController.swift
//  helpDesk
//
//  Created by Wybren Oppedijk on 17-12-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import UIKit

class changePasswordViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var textfieldOldPassword: UITextField!
    @IBOutlet weak var textfieldNewPassword: UITextField!
    @IBOutlet weak var textfieldNewPasswordConfirm: UITextField!
    
    let defaultData = NSUserDefaults.standardUserDefaults()
    let dbURL = "wybren.haptotherapie-twente.nl/changePassword.php" as String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePasswordButtonTapped(sender: AnyObject) {
        let oldPasswordAttempt = textfieldOldPassword.text!
        let oldPasswordOriginal = defaultData.objectForKey("Password") as! String
        let newPassword = textfieldNewPassword.text!
        let newPasswordConfirm = textfieldNewPasswordConfirm.text!
        let username = defaultData.objectForKey("Username") as! String
        
        if(oldPasswordOriginal != oldPasswordAttempt) {
            let alertView:UIAlertController = UIAlertController(title: "Wijzigen mislukt", message: "Het oude wachtwoord is incorrect.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertView.addAction(OKAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            
        } else if(newPassword != newPasswordConfirm) {
            let alertView:UIAlertController = UIAlertController(title: "Wijzigen mislukt", message: "De nieuwe wachtwoorden komen niet overeen.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertView.addAction(OKAction)
            self.presentViewController(alertView, animated: true, completion: nil)

        } else {
            changePasswordInDatabase(username, password: newPassword)
        }
        
    }
    
    internal func changePasswordInDatabase(username: NSString, password: NSString) -> Void {
        // TODO: This function
    }
}