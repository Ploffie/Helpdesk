//
//  AppDelegate.swift
//  helpDesk
//
//  Created by Thuis on 04-11-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let log = loginPortalViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        let username = defaultData.stringForKey(dataUsername)
        let password = defaultData.stringForKey(dataPassword)
        
        if(defaultData.objectForKey(dataCredentialsSaved) == nil ||
            defaultData.boolForKey(dataCredentialsSaved) == false) {
                
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier(entryUnprotected) as! SWRevealViewController
                
            self.window?.rootViewController = exampleViewController
            self.window?.makeKeyAndVisible()

            return true
        } else {
            Alamofire.request(.POST, loginURL, parameters: [requestUsername: username!, requestPassword: password!])
                .responseJSON { response in switch response.result {
                case .Success(let JSON):
                    let response = JSON as! NSDictionary
                    
                    if(response.valueForKey(responseError) != nil) {
                        
                        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier(entryUnprotected) as! SWRevealViewController
                        
                        self.window?.rootViewController = exampleViewController
                        self.window?.makeKeyAndVisible()

                    } else if(response.valueForKey(responseCompany) != nil &&
                        response.valueForKey(responseUser) != nil &&
                        response.valueForKey(responseOccupation) != nil &&
                        response.valueForKey(responseSystem) != nil) {
                            
                            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                            
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier(entryProtected) as! SWRevealViewController
                            
                            self.window?.rootViewController = exampleViewController
                            self.window?.makeKeyAndVisible()

                            break
                            
                    } else {
                        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier(entryUnprotected) as! SWRevealViewController
                        
                        self.window?.rootViewController = exampleViewController
                        self.window?.makeKeyAndVisible()
                        print(response.debugDescription)
                        break // Neat error handling is neat
                    }
                    
                    break
                case .Failure(_):
                    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier(entryUnprotected) as! SWRevealViewController
                    
                    self.window?.rootViewController = exampleViewController
                    self.window?.makeKeyAndVisible()
                    print(response.debugDescription)
                    break

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