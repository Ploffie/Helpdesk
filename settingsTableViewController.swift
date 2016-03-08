//
//  settingsTableViewController.swift
//  helpDesk
//
//  Created by Wybren Oppedijk on 08-03-16.
//  Copyright © 2016 Amerion IT. All rights reserved.
//

import UIKit

class settingsTableViewController: UITableViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var dataSaveSwitch: UISwitch!
    
    private let Alert = alertViewFunction()
    private let alertController = UIAlertController(title: deleteDataTitle, message: deleteDataQuestionMessage, preferredStyle: UIAlertControllerStyle.Alert)
    private let confirmAlertController = UIAlertController(title: deleteDataTitle, message: deleteDataYesMessage, preferredStyle: UIAlertControllerStyle.Alert)
    var window:UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let yesDeleteDataAction = UIAlertAction(title: "Ja", style: UIAlertActionStyle.Destructive) {
            UIAlertAction in
            deleteData()
            defaultData.removeObjectForKey(dataCredentialsSaved)
            defaultData.removeObjectForKey(dataMessagesDeleted)
            self.presentViewController(self.confirmAlertController, animated: true, completion: nil)
        }
        
        let noDeleteDataAction = UIAlertAction(title: "Nee", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            // Do nothing, just dismiss view controller.
        }
        
        let confirmDataDeletedAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let exampleViewController: SWRevealViewController = mainStoryboard.instantiateViewControllerWithIdentifier(entryUnprotected) as! SWRevealViewController
            
            self.window?.rootViewController = exampleViewController
            self.window?.makeKeyAndVisible()
        }
        
        alertController.addAction(yesDeleteDataAction)
        alertController.addAction(noDeleteDataAction)
        confirmAlertController.addAction(confirmDataDeletedAction)
        
        let doesSaveData:Bool = defaultData.boolForKey(dataCredentialsSaved)
        dataSaveSwitch.setOn(doesSaveData, animated: false)
    }
    
    @IBAction func dataSaveSwitched(sender: AnyObject) {
        if(dataSaveSwitch.on) {
            defaultData.setBool(true, forKey: dataCredentialsSaved)
        } else {
            defaultData.setBool(false, forKey: dataCredentialsSaved)
        }
        defaultData.synchronize()
    }
    
    @IBAction func deleteDataPressed(sender: AnyObject) {
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
