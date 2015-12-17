//
//  alertMessageTableViewController.swift
//  helpDesk
//
//  Created by Wybren Oppedijk on 10-12-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import UIKit

class alertMessageTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("labelCell", forIndexPath: indexPath)

        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }


 
}
