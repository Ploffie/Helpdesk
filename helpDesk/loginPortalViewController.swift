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
import Alamofire

public class loginPortalViewController: UIViewController {
    
    // All programmed
    
    private let dbURL:String = "http://wybren.haptotherapie-twente.nl/jsonlogin2.php"
    private let Alert = alertViewFunction()
    
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
        let username:String = usernameTextfield.text!
        let password:String = passwordTextfield.text!
        
        if ( username == "" || password == "" ) {
            self.presentViewController(Alert.create("Inloggen mislukt", message: "Vul a.u.b. een gebruikersnaam en wachtwoord in."), animated: true, completion: nil)
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
        self.presentViewController(Alert.create("Registreren", message: "Neem contact op met Amerion IT om te registreren."), animated: true, completion: nil)
        
    }
    
    public func handleLogin(username: String, password: String) -> Int {
        Alamofire.request(.POST, dbURL, parameters: ["username": username, "password": password])
            .responseJSON { response in
                let HTTPStatusCode = response.response!.statusCode
                let JSONResponse = response.result.value
                if(!(HTTPStatusCode > 0)) {
                    self.presentViewController(self.Alert.create("Inloggen mislukt", message: "Er is geen verbinding met de server. Heeft u een werkende internetverbinding?"), animated: true, completion: nil)
                } else if(!(HTTPStatusCode >= 200 && HTTPStatusCode < 300)) {
                    self.presentViewController(self.Alert.create("Inloggen mislukt", message: "Er heeft zich een fout opgetreden (statuscode \(HTTPStatusCode)."), animated: true, completion: nil)
                } else if(JSONResponse == nil) { // DATABASE RETURNS NIL
                        self.presentViewController(self.Alert.create("Inloggen mislukt", message: "Er heeft zich een serverfout opgetreden (foutcode i01)"), animated: true, completion: nil)
                } else if(JSONResponse!.valueForKey("success") != nil) {
                    self.presentViewController(self.Alert.create("Inloggen mislukt", message: JSONResponse!.valueForKey("error_message") as! String), animated: true, completion: nil)
                }
                print("JSON Response: \(response.result.value)")
            }
        return 0
    }
    
    public func handleLoginNoAlert(username: NSString, password: NSString) -> Int {
        return 0
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
