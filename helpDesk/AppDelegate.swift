//
//  AppDelegate.swift
//  helpDesk
//
//  Created by Thuis on 04-11-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

/*
 * TODO:
 *
 * Nothing so far
 */

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Mostly programmed manually, apart from empty functions

    var window: UIWindow?
    let defaultData = NSUserDefaults.standardUserDefaults()
    let log = loginPortalViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        let username = defaultData.stringForKey("Username")
        let password = defaultData.stringForKey("Password")
        let dbURL = "http://wybren.haptotherapie-twente.nl/jsonlogin2.php"
        
        if(defaultData.objectForKey("Username") == nil ||
            defaultData.objectForKey("Password") == nil) {
                
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier("unprotectedEntryPoint") as! SWRevealViewController
                
            self.window?.rootViewController = exampleViewController
            self.window?.makeKeyAndVisible()
                
            return true
        } else {
            Alamofire.request(.POST, dbURL, parameters: ["username": username!, "password": password!])
                    .responseJSON { response in
                        
                        let HTTPStatusCode = response.response?.statusCode
                        let JSONResponse = response.result.value!
                        
                        if(!(HTTPStatusCode > 0)) {
                            
                            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                            
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier("unprotectedEntryPoint") as! SWRevealViewController
                            
                            self.window?.rootViewController = exampleViewController
                            self.window?.makeKeyAndVisible()

                            return
                            
                        } else if(!(HTTPStatusCode >= 200 && HTTPStatusCode < 300)) {
                            
                            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                            
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier("unprotectedEntryPoint") as! SWRevealViewController
                            
                            self.window?.rootViewController = exampleViewController
                            self.window?.makeKeyAndVisible()

                            return
                            
                        } else if(JSONResponse.valueForKey("company") != nil &&
                            JSONResponse.valueForKey("id") != nil &&
                            JSONResponse.valueForKey("occupation") != nil &&
                            JSONResponse.valueForKey("system") != nil) {
                                
                                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                                
                                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier("protectedEntryPoint") as! SWRevealViewController
                                
                                self.window?.rootViewController = exampleViewController
                                self.window?.makeKeyAndVisible()
                                
                                return
                                
                        } else { // No idea when code will reach this point, better be safe than sure
                            
                            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                            
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier("unprotectedEntryPoint") as! SWRevealViewController
                            
                            self.window?.rootViewController = exampleViewController
                            self.window?.makeKeyAndVisible()
                            
                            return
                            
                        }
                }
            
        return true // Code shouldn't reach this point, no idea what will happen.
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}