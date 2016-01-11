//
//  newsViewController.swift
//  helpDesk
//
//  Created by Thuis on 04-11-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

/* 
 * TODO:
 *
 * Optimise memory usage, create one alertView and customise later
 * Instead of defining a new one every time
 *
 * Optimisation, handle login return statement outside of
 * handleLogin function but in login class instead
 *
 * Ask whether user wants to save credentials or not
 */

import UIKit

public class loginPortalViewController: UIViewController {
    
    // All programmed
    
    private let dbURL:String = "http://wybren.haptotherapie-twente.nl/jsonlogin2.php"
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    public let defaultData = NSUserDefaults.standardUserDefaults()
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButton(sender: UIButton) {
        let username:NSString = usernameTextfield.text!
        let password:NSString = passwordTextfield.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let alertView:UIAlertController = UIAlertController(title: "Inloggen mislukt", message: "Vul a.u.b. een gebruikersnaam en wachtwoord in.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertView.addAction(OKAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        } else {
            handleLogin(username, password: password)
            self.performSegueWithIdentifier("goto_protected", sender: self)
        }
        
    }
    
    @IBAction func passwordDidEndOnExit(sender: UITextField) {
        handleLogin(usernameTextfield.text!, password: passwordTextfield.text!)
        self.performSegueWithIdentifier("goto_protected", sender: self)
    }

    @IBAction func signUpButton(sender: UIButton) {
        
        let alertView:UIAlertController = UIAlertController(title: "Registreren", message: "Neem contact op met Amerion IT om te registreren.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertView.addAction(OKAction)
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    public func handleLogin(username: NSString, password: NSString) -> Int {
        
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
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response) // Deprecated
            } catch let error as NSError {
                reponseError = error
                urlData = nil
            }
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    let userID:NSString = jsonData.valueForKey("userID") as! NSString
                    let userOccupation:NSString = jsonData.valueForKey("userOccupation") as! NSString
                    let userCompany:NSString = jsonData.valueForKey("userCompany") as! NSString
                    
                    if(success == 1)
                    {
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        
                        defaultData.setObject(username, forKey: "Username")
                        defaultData.setObject(password, forKey: "Password")
                        defaultData.setObject(userID, forKey: "userID")
                        defaultData.setObject(userOccupation, forKey: "userOccupation")
                        defaultData.setObject(userCompany, forKey: "userCompany")
                        defaultData.synchronize()
                        
                        print(userID)
                        print(userOccupation)
                        print(userCompany)
                        
                        return 1
                
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Er is een fout opgetreden, probeer het later opnieuw."
                        }
                        let alertView:UIAlertController = UIAlertController(title: "Inloggen mislukt", message: error_msg as String, preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertView.addAction(OKAction)
                        self.presentViewController(alertView, animated: true, completion: nil)
                        
                        return 0
                    }
                    
                } else {
                    let alertView:UIAlertController = UIAlertController(title: "Inloggen mislukt", message: "Er is een fout opgetreden (foutcode i01).", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alertView.addAction(OKAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                    return 0
                }
            } else {
                let alertView:UIAlertController = UIAlertController(title: "Inloggen mislukt", message: "Er is een fout opgetreden (foutcode i02).", preferredStyle: .Alert)
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                
                return 0
            }
        } catch {
            let alertView:UIAlertController = UIAlertController(title: "Inloggen mislukt", message: "Er is een fout opgetreden (foutcode i03).", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertView.addAction(OKAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        return 0
    }
    
    public func handleLoginNoAlert(username: NSString, password: NSString) -> Int {
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
            } catch {
                urlData = nil
            }
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    
                    if(success == 1)
                    {
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        
                        defaultData.setObject(username, forKey: "Username")
                        defaultData.setObject(password, forKey: "Password")
                        defaultData.synchronize()
                        
                        return 1
                        
                    } else {
                        // Do nothing
                        return 0
                    }
                    
                } else {
                    // Do nothing
                    return 0
                }
            } else {
                // Do nothing
                return 0
            }
        } catch {
            // Do nothing
            return 0
        }
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
