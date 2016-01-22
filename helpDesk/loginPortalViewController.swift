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
    
    let defaultData = NSUserDefaults.standardUserDefaults()
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
            if(handleLogin(username, password: password) == 1) {
                self.performSegueWithIdentifier("goto_protected", sender: self)
            }
        }
        
    }
    
    @IBAction func passwordDidEndOnExit(sender: UITextField) {
        if(handleLogin(usernameTextfield.text!, password: passwordTextfield.text!) == 1) {
            self.performSegueWithIdentifier("goto_protected", sender: self)
        }
    }

    @IBAction func signUpButton(sender: UIButton) {
        
        let alertView:UIAlertController = UIAlertController(title: "Registreren", message: "Neem contact op met Amerion IT om te registreren.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertView.addAction(OKAction)
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    public func handleLogin(username: NSString, password: NSString) -> Int {
        
        let url:NSURL = NSURL(string: "http://wybren.haptotherapie-twente.nl/jsonlogin2.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let bodyData = "username=\(username)&password=\(password)"
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            let res = response as! NSHTTPURLResponse
            if(res.statusCode >= 200 && res.statusCode < 300) {
                let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            }
        })
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
