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
            Alamofire.request(.POST, dbURL, parameters: ["username": username, "password": password])
                .responseJSON { response in switch response.result {
                    
                case .Success(let JSON):
                    
                    let response = JSON as! NSDictionary
                    
                    if(response.valueForKey("error_message") != nil) {
                        
                        self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: response.valueForKey("error_message")!                           as! String), animated: true, completion: nil)
                        
                    } else if(response.valueForKey("company") != nil &&
                        response.valueForKey("id") != nil &&
                        response.valueForKey("occupation") != nil &&
                        response.valueForKey("system") != nil) {
                            
                            self.defaultData.setValue(username, forKey: "Username")
                            self.defaultData.setValue(password, forKey: "Password")
                            
                            self.defaultData.setValue(response.valueForKey("company")!, forKey: "Company")
                            self.defaultData.setValue(response.valueForKey("id")!, forKey: "ID")
                            self.defaultData.setValue(response.valueForKey("occupation")!, forKey: "Occupation")
                            self.defaultData.setValue(response.valueForKey("system")!, forKey: "System")
                            
                            self.defaultData.synchronize()
                            self.performSegueWithIdentifier("goto_protected", sender: self)
                            break
                            
                    } else {
                        
                        self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er heeft zich een onbekende fout opgetreden."), animated: true, completion: nil)
                        print(response.debugDescription)
                        break // Neat error handling is neat
                        
                    }
                    break
                case .Failure(_):
                    
                    self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er heeft zich een fout opgetreden. Heeft u een werkende internetverbinding?"), animated: true, completion: nil)
                    print(response.debugDescription)
                    break
                    
                }
            }
        }
        
    }
    
    @IBAction func passwordDidEndOnExit(sender: UITextField) {
        
        let username:String = usernameTextfield.text!
        let password:String = passwordTextfield.text!
        
        if ( username == "" || password == "" ) {
            
            self.presentViewController(Alert.create("Inloggen mislukt", message: "Vul a.u.b. een gebruikersnaam en wachtwoord in."), animated: true, completion: nil)
            
        } else {
            
            Alamofire.request(.POST, dbURL, parameters: ["username": username, "password": password])
                .responseJSON { response in switch response.result {
                    
                case .Success(let JSON):
                    
                    let response = JSON as! NSDictionary
                    
                    if(response.valueForKey("error_message") != nil) {
                        
                        self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: response.valueForKey("error_message")!                           as! String), animated: true, completion: nil)
                        
                    } else if(response.valueForKey("company") != nil &&
                           response.valueForKey("id") != nil &&
                           response.valueForKey("occupation") != nil &&
                           response.valueForKey("system") != nil) {
                            
                            self.defaultData.setValue(username, forKey: "Username")
                            self.defaultData.setValue(password, forKey: "Password")
                            
                            self.defaultData.setValue(response.valueForKey("company")!, forKey: "Company")
                            self.defaultData.setValue(response.valueForKey("id")!, forKey: "ID")
                            self.defaultData.setValue(response.valueForKey("occupation")!, forKey: "Occupation")
                            self.defaultData.setValue(response.valueForKey("system")!, forKey: "System")
                            
                            self.defaultData.synchronize()
                            self.performSegueWithIdentifier("goto_protected", sender: self)
                            break

                    } else {
                        
                        self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er heeft zich een onbekende fout opgetreden."), animated: true, completion: nil)
                        print(response.debugDescription)
                        break // Neat error handling is neat
                        
                    }
                    break
                case .Failure(_):
                    
                    self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er heeft zich een fout opgetreden. Heeft u een werkende internetverbinding?"), animated: true, completion: nil)
                    print(response.debugDescription)
                    break
                    
                    }
            }
        }

    }

    @IBAction func signUpButton(sender: UIButton) {
        self.presentViewController(Alert.create("Registreren", message: "Neem contact op met Amerion IT om te registreren."), animated: true, completion: nil)
        
    }
    
    //public function handleLoginSuccess(
    
}


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/
