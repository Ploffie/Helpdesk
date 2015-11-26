//
//  userPortalViewController.swift
//  helpDesk
//
//  Created by Thuis on 04-11-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import UIKit

class userPortalViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    @IBAction func loginButton(sender: UIButton) {
        
        let userEmail = usernameTextField.text
        let userPassword = passwordTextField.text
        
        if(userPassword!.isEmpty || userPassword!.isEmpty) {return; }
        
        let myUrl = NSURL(string: "http://192.168.1.25:8000/userLogin.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "username=\(userEmail)&password=\(userPassword)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            
        
            
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                    
                
                if let parseJSON = json {
                    let resultValue:String = parseJSON["status"] as! String!;
                    print("result: \(resultValue)")
                    
                    if(resultValue=="Success"){
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn");
                        NSUserDefaults.standardUserDefaults().synchronize();
                        
                        self.dismissViewControllerAnimated(true, completion: nil);
                    }
                }
            }catch
            {
            print(error)
            }
            
            }

    task.resume()
    
    }
    
    
    
    
    
//    private func handleLogin() {
//        if(textfieldUsernameOutlet.text == "" || textfieldPasswordOutlet.text == "") {
//            
//        } else if (textfieldUsernameOutlet.text == "admin" && textfieldPasswordOutlet.text == "password") {
//            loginButtonOutlet.titleLabel!.text = "Correct";
//        } else {
//            loginButtonOutlet.titleLabel!.text = "Incorrect";
//        }
//
//    }
//    
//    @IBAction func loginButton(sender: UIButton) {
//        handleLogin()
//    }
//    
//    @IBAction func textfieldUsername(sender: UITextField) {
//        handleLogin()
//    }
//    
//    @IBAction func textfieldPassword(sender: UITextField) {
//        handleLogin()
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
