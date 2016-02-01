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
    public var loginReturn:Bool?
    
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
                .responseJSON { response in
                    debugPrint(response)
                    
                    let HTTPStatusCode = response.response?.statusCode
                    let JSONResponse = response.result.value
                    
                    if(!(HTTPStatusCode > 0)) {
                        self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er is geen verbinding met de server. Heeft u een werkende internetverbinding?"), animated: true, completion: nil)
                        return
                        
                    } else if(!(HTTPStatusCode >= 200 && HTTPStatusCode < 300)) {
                        self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er heeft zich een fout opgetreden (statuscode \(HTTPStatusCode))."), animated: true, completion: nil)
                        return
                        
                    } else if let jsonResult = JSONResponse as? Array<Dictionary<String, Int>> {
                        let company:Int = jsonResult[0]["company"]!
                        let id:Int = jsonResult[0]["id"]!
                        let occupation:Int = jsonResult[0]["occupation"]!
                        let system:Int = jsonResult[0]["system"]!
                        
                        if(company != 0 &&
                           id != 0 &&
                           occupation != 0 &&
                           system != 0) {
                            self.defaultData.setValue(company, forKey: "Company")
                            self.defaultData.setValue(id, forKey: "ID")
                            self.defaultData.setValue(occupation, forKey: "Occupation")
                            self.defaultData.setValue(system, forKey: "System")
                            self.defaultData.synchronize()
                            self.performSegueWithIdentifier("goto_protected", sender: self)
                            return

                        } else { // No idea when code will reach this point, better be safe than sure
                            self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er heeft zich een onbekende fout opgetreden."), animated: true, completion: nil)
                            print("Debug2")
                            print(JSONResponse)
                            return
                        }
                    } else {
                        print("--------------------")
                        print("error 1337gonewrong")
                        print(JSONResponse)
                        print("--------------------")
                        print(JSONResponse)
                        print("--------------------")
                    }
            }
        }
        
    }
    
    @IBAction func passwordDidEndOnExit(sender: UITextField) {
        let username:String = usernameTextfield.text!
        let password:String = passwordTextfield.text!
        Alamofire.request(.POST, dbURL, parameters: ["username": username, "password": password])
            .responseJSON { response in
                let HTTPStatusCode = response.response?.statusCode
                let JSONResponse = response.result.value
                if(!(HTTPStatusCode > 0)) {
                    self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er is geen verbinding met de server. Heeft u een werkende internetverbinding?"), animated: true, completion: nil)
                    return
                } else if(!(HTTPStatusCode >= 200 && HTTPStatusCode < 300)) {
                    self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er heeft zich een fout opgetreden (statuscode \(HTTPStatusCode))."), animated: true, completion: nil)
                    return
                } else if(JSONResponse == nil) { // Shouldn't happen, coded to prevent app from crashing
                    self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er heeft zich een onbekende fout opgetreden."), animated: true, completion: nil)
                    return
                } else if(JSONResponse!.valueForKey("company") != nil ||
                    JSONResponse!.valueForKey("id") != nil ||
                    JSONResponse!.valueForKey("occupation") != nil ||
                    JSONResponse!.valueForKey("system") != nil) {
                        self.defaultData.setValue(JSONResponse!.valueForKey("company"), forKey: "Company")
                        self.defaultData.setValue(JSONResponse!.valueForKey("id"), forKey: "ID")
                        self.defaultData.setValue(JSONResponse!.valueForKey("occupation"), forKey: "Occupation")
                        self.defaultData.setValue(JSONResponse!.valueForKey("system"), forKey: "System")
                        self.defaultData.synchronize()
                        self.performSegueWithIdentifier("goto_protected", sender: self)
                        return
                } else { // No idea when code will reach this point, better be safe than sure
                    self.presentViewController(alertViewFunction().create("Inloggen mislukt", message: "Er heeft zich een onbekende fout opgetreden."), animated: true, completion: nil)
                    return
                }
        }

    }

    @IBAction func signUpButton(sender: UIButton) {
        self.presentViewController(Alert.create("Registreren", message: "Neem contact op met Amerion IT om te registreren."), animated: true, completion: nil)
        
    }
    
    public func handleLoginNoAlert(username: NSString, password: NSString) -> Bool {
        return false
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
