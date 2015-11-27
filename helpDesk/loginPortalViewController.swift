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
 */

import UIKit

public class loginPortalViewController: UIViewController {
    
    // All programmed apart from function handleLogin, which will be moved to general Helpdesk file soon
    // handleLogin function was, however, created manually
    
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
            
            let alertView:UIAlertController = UIAlertController(title: "Sign in failed", message: "Please enter username and password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertView.addAction(OKAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        } else {
            handleLogin(username, password: password)
        }
        
    }
    
    @IBAction func passwordDidEndOnExit(sender: UITextField) {
        handleLogin(usernameTextfield.text!, password: passwordTextfield.text!)
    }
    
    
    public func handleLogin(username: NSString, password: NSString) -> Void {
        
        do {
            let post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
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
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    //var error: NSError?
                    
                    let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    
                    
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        NSLog("Login SUCCESS");
                        
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        
                        defaultData.setObject(username, forKey: "standardUser")
                        defaultData.setObject(password, forKey: "standardPass")
                        
                        self.performSegueWithIdentifier("goto_login", sender: self)
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        let alertView:UIAlertController = UIAlertController(title: "Sign in failed", message: error_msg as String, preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertView.addAction(OKAction)
                        self.presentViewController(alertView, animated: true, completion: nil)
                        
                    }
                    
                } else {
                    let alertView:UIAlertController = UIAlertController(title: "Sign in failed", message: "Connection failed", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alertView.addAction(OKAction)
                    self.presentViewController(alertView, animated: true, completion: nil)

                }
            } else {
                let alertView:UIAlertController = UIAlertController(title: "Sign in failed", message: "Connection failure", preferredStyle: .Alert)
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)

            }
        } catch {
            let alertView:UIAlertController = UIAlertController(title: "Sign in failed", message: "Server error", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertView.addAction(OKAction)
            self.presentViewController(alertView, animated: true, completion: nil)
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
