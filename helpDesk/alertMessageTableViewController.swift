//
//  alertMessageTableTableViewController.swift
//  helpDesk
//
//  Created by Wybren Oppedijk on 02-02-16.
//  Copyright © 2016 Amerion IT. All rights reserved.
//

import UIKit
import Alamofire

class alertMessageTableViewController: UITableViewController {
    
    private let defaultData = NSUserDefaults.standardUserDefaults()
    
    private let dbURL = "http://wybren.haptotherapie-twente.nl/getData.php"
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let company = self.defaultData.valueForKey("Company")!
        let id = self.defaultData.valueForKey("ID")!
        let occupation = self.defaultData.valueForKey("Occupation")!
        let system = self.defaultData.valueForKey("System")!
        
        Alamofire.request(.POST, dbURL, parameters: ["companyID": company, "userID": id,"occupationID": occupation, "systemID": system])
            .responseJSON { response in switch response.result {
            case .Success(let JSON):
                let response = JSON as! NSDictionary
                let responseMessages = response.valueForKey("messages")![0] // Has keys "message", "title", and "username"
                let amountOfMessages = response.valueForKey("amountOfMessages")! // Has keys "amountOfMessages" (handled here), and "messages" (handled above)
                break
            case .Failure(_):
                // Handle failure
                debugPrint(response.request)
                print("---------- FAILURE ----------")
                break
                }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
