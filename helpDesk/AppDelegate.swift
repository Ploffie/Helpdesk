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
 * Save user credentials onto iPhone/iPad memory
 * Log in again as soon as user re-opens app
 * And set initial view controller as protected view controller
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Generated code, apart from code within functions and let values

    var window: UIWindow?
    let defaultData = NSUserDefaults.standardUserDefaults()
    let loginControllerClass = loginPortalViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        defaultData.setValue("Username", forKey: "admin") // DEBUG
        defaultData.setValue("Password", forKey: "password") // DEBUG
        let username = defaultData.stringForKey("Username")
        let password = defaultData.stringForKey("Password")
        if(defaultData.objectForKey("Username") == nil ||
            defaultData.objectForKey("Password") == nil) {
            print("Missing value for username/password, not logging in") // DEBUG
            // Do nothing
        } else {
            print("Username and password are available, attempting login") // DEBUG
            loginControllerClass.handleLogin(username!, password: password!)
        }
        
        return true
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

