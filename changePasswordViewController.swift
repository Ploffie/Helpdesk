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
        do {
            let post:NSString = "username=\(username)&password=\(password)"
            
            let url:NSURL = NSURL(string:dbURL)!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response) // Deprecated
            
                if ( urlData != nil ) {
                    let res = response as! NSHTTPURLResponse!;
                
                    if (res.statusCode >= 200 && res.statusCode < 300) {
                        let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                        let success:NSInteger = jsonData.valueForKey("succes") as! NSInteger
                        if(success == 1) {
                            let alertView:UIAlertController = UIAlertController(title: "Wachtwoord gewijzigd", message: "Uw wachtwoord is gewijzigd.", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                            alertView.addAction(OKAction)
                            self.presentViewController(alertView, animated: true, completion: nil)
                        } else {
                            let alertView:UIAlertController = UIAlertController(title: "Wachtwoord niet gewijzigd", message: "Er is een fout opgetreden (foutcode i10).", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                            alertView.addAction(OKAction)
                            self.presentViewController(alertView, animated: true, completion: nil)
                        }
                    } else {
                        let alertView:UIAlertController = UIAlertController(title: "Wachtwoord niet gewijzigd", message: "Er is een fout opgetreden (foutcode i07).", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertView.addAction(OKAction)
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                } else {
                    let alertView:UIAlertController = UIAlertController(title: "Wachtwoord niet gewijzigd", message: "Er is een fout opgetreden (foutcode i08).", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alertView.addAction(OKAction)
                    self.presentViewController(alertView, animated: true, completion: nil)            }
            } catch {
                let alertView:UIAlertController = UIAlertController(title: "Wachtwoord niet gewijzigd", message: "Er is een fout opgetreden (foutcode i09).", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }

        }
    
    }
}