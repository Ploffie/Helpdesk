//
//  newsViewController.swift
//  helpDesk
//
//  Created by Thuis on 04-11-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import UIKit
import Alamofire

public class loginPortalViewController: UIViewController {
    
    // All programmed
    
    private let Alert = alertViewFunction()
    
    private let alertController = UIAlertController(title: savePasswordTitle, message: savePasswordMessage, preferredStyle: .Alert)
    
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
            
            self.presentViewController(Alert.create(errorTitle, message: errorMessages[0]), animated: true, completion: nil)
            
        } else {
            Alamofire.request(.POST, loginURL, parameters: [requestUsername: username, requestPassword: password])
                .responseJSON { response in switch response.result {
                    
                case .Success(let JSON):
                    
                    let response = JSON as! NSDictionary
                    
                    if(response.valueForKey(responseError) != nil) {
                        
                        self.presentViewController(alertViewFunction().create(errorTitle, message: response.valueForKey(responseError)! as! String), animated: true, completion: nil)
                        
                    } else if(response.valueForKey(responseCompany) != nil &&
                        response.valueForKey(responseUser) != nil &&
                        response.valueForKey(responseOccupation) != nil &&
                        response.valueForKey(responseSystem) != nil) {
                            
                            if(self.defaultData.objectForKey(dataCredentialsSaved) == nil) {
                            
                            let rememberPasswordAction = UIAlertAction(title: "Ja", style: UIAlertActionStyle.Default) {
                                UIAlertAction in
                                self.defaultData.setValue(username, forKey: dataUsername)
                                self.defaultData.setValue(password, forKey: dataPassword)
                                
                                self.defaultData.setBool(true, forKey: dataCredentialsSaved)
                                
                                self.defaultData.setValue(response.valueForKey(responseCompany)!, forKey: dataCompany)
                                self.defaultData.setValue(response.valueForKey(responseUser)!, forKey: dataUser)
                                self.defaultData.setValue(response.valueForKey(responseOccupation)!, forKey: dataOccupation)
                                self.defaultData.setValue(response.valueForKey(responseSystem)!, forKey: dataSystem)
                                
                                self.defaultData.synchronize()
                                self.performSegueWithIdentifier(gotoProtected, sender: self)
                            }
                            
                            let noRememberPasswordAction = UIAlertAction(title: "Nee", style: UIAlertActionStyle.Default) {
                                UIAlertAction in
                                self.defaultData.setValue(username, forKey: dataUsername)
                                self.defaultData.setValue(password, forKey: dataPassword)
                                
                                self.defaultData.setBool(false, forKey: dataCredentialsSaved)
                                
                                self.defaultData.setValue(response.valueForKey(responseCompany)!, forKey: dataCompany)
                                self.defaultData.setValue(response.valueForKey(responseUser)!, forKey: dataUser)
                                self.defaultData.setValue(response.valueForKey(responseOccupation)!, forKey: dataOccupation)
                                self.defaultData.setValue(response.valueForKey(responseSystem)!, forKey: dataSystem)
                                
                                self.defaultData.synchronize()
                                self.performSegueWithIdentifier(gotoProtected, sender: self)
                            }
                            
                            self.alertController.addAction(noRememberPasswordAction)
                            self.alertController.addAction(rememberPasswordAction)
                            
                            self.presentViewController(self.alertController, animated: true, completion: nil)
                                
                            } else {
                                self.defaultData.setValue(username, forKey: dataUsername)
                                self.defaultData.setValue(password, forKey: dataPassword)

                                self.defaultData.setValue(response.valueForKey(responseCompany)!, forKey: dataCompany)
                                self.defaultData.setValue(response.valueForKey(responseUser)!, forKey: dataUser)
                                self.defaultData.setValue(response.valueForKey(responseOccupation)!, forKey: dataOccupation)
                                self.defaultData.setValue(response.valueForKey(responseSystem)!, forKey: dataSystem)
                                
                                self.defaultData.synchronize()
                                self.performSegueWithIdentifier(gotoProtected, sender: self)
                            }
                            
                            break
                            
                    } else {
                        
                        self.presentViewController(alertViewFunction().create(errorTitle, message: errorMessages[1]), animated: true, completion: nil)
                        print(response.debugDescription)
                        break // Neat error handling is neat
                        
                    }
                    break
                case .Failure(_):
                    
                    self.presentViewController(alertViewFunction().create(errorTitle, message: errorMessages[2]), animated: true, completion: nil)
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
            
            self.presentViewController(Alert.create(errorTitle, message: errorMessages[0]), animated: true, completion: nil)
            
        } else {
            Alamofire.request(.POST, loginURL, parameters: [requestUsername: username, requestPassword: password])
                .responseJSON { response in switch response.result {
                    
                case .Success(let JSON):
                    
                    let response = JSON as! NSDictionary
                    
                    if(response.valueForKey(responseError) != nil) {
                        
                        self.presentViewController(alertViewFunction().create(errorTitle, message: response.valueForKey(responseError)! as! String), animated: true, completion: nil)
                        
                    } else if(response.valueForKey(responseCompany) != nil &&
                        response.valueForKey(responseUser) != nil &&
                        response.valueForKey(responseOccupation) != nil &&
                        response.valueForKey(responseSystem) != nil) {
                            
                            if(self.defaultData.objectForKey(dataCredentialsSaved) == nil) {
                                
                                let rememberPasswordAction = UIAlertAction(title: "Ja", style: UIAlertActionStyle.Default) {
                                    UIAlertAction in
                                    
                                    self.defaultData.setBool(true, forKey: dataCredentialsSaved)
                                }
                                
                                let noRememberPasswordAction = UIAlertAction(title: "Nee", style: UIAlertActionStyle.Default) {
                                    UIAlertAction in
                                    
                                    self.defaultData.setBool(false, forKey: dataCredentialsSaved)
                                }
                                
                                self.alertController.addAction(noRememberPasswordAction)
                                self.alertController.addAction(rememberPasswordAction)
                                
                                self.defaultData.setValue(username, forKey: dataUsername)
                                self.defaultData.setValue(password, forKey: dataPassword)

                                self.defaultData.setValue(response.valueForKey(responseCompany)!, forKey: dataCompany)
                                self.defaultData.setValue(response.valueForKey(responseUser)!, forKey: dataUser)
                                self.defaultData.setValue(response.valueForKey(responseOccupation)!, forKey: dataOccupation)
                                self.defaultData.setValue(response.valueForKey(responseSystem)!, forKey: dataSystem)
                                
                                // MARK
                                Alamofire.request(.POST, messageURL, parameters: [requestCompany: response.valueForKey(responseCompany)!, requestUser: response.valueForKey(responseUser)!, requestOccupation: response.valueForKey(responseOccupation)!, requestSystem: response.valueForKey(responseSystem)!])
                                    .responseJSON { response in switch response.result {
                                    case .Success(let JSON):
                                        let response = JSON as! NSDictionary
                                        let responseMessageList = response.valueForKey(responseMessages)!
                                        self.defaultData.setValue(responseMessageList, forKey: dataMessages)
                                        break
                                    case .Failure(_):
                                        debugPrint(response.request)
                                        break
                                    }
                                }
                                
                                self.defaultData.synchronize()
                                self.performSegueWithIdentifier(gotoProtected, sender: self)
                                self.presentViewController(self.alertController, animated: true, completion: nil)
                                
                            } else {
                                self.defaultData.setValue(username, forKey: dataUsername)
                                self.defaultData.setValue(password, forKey: dataPassword)
                                
                                self.defaultData.setValue(response.valueForKey(responseCompany)!, forKey: dataCompany)
                                self.defaultData.setValue(response.valueForKey(responseUser)!, forKey: dataUser)
                                self.defaultData.setValue(response.valueForKey(responseOccupation)!, forKey: dataOccupation)
                                self.defaultData.setValue(response.valueForKey(responseSystem)!, forKey: dataSystem)
                                
                                self.defaultData.synchronize()
                                self.performSegueWithIdentifier(gotoProtected, sender: self)
                            }
                            
                            break
                            
                    } else {
                        
                        self.presentViewController(alertViewFunction().create(errorTitle, message: errorMessages[1]), animated: true, completion: nil)
                        print(response.debugDescription)
                        break // Neat error handling is neat
                        
                    }
                    break
                case .Failure(_):
                    
                    self.presentViewController(alertViewFunction().create(errorTitle, message: errorMessages[2]), animated: true, completion: nil)
                    print(response.debugDescription)
                    break
                    
                    }
            }
        }
    }

    @IBAction func signUpButton(sender: UIButton) {
        self.presentViewController(Alert.create(registerTitle, message: registerMessage), animated: true, completion: nil)
        
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
