//
//  kidListTableViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/10/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit

class kidListTableViewController: UITableViewController {
    
    var kids = [Kid]()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        loadSampleKids()
    }
    // TODO: load real kids and their views. Incorporate NSData and Heroku server
    func loadSampleKids() {
        kids += [Kid(name: "Johnny", phone: 8903873728)!]
        let kid1 = Kid(name: "Suzy")
        kid1?.isConfirmed = true
        kid1?.routes = [Route(time:NSDate()), Route(time: NSDate(timeIntervalSinceNow: 398398))]
        kids += [kid1!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kids.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "kidListTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! kidListTableViewCell
        
        let kid = kids[indexPath.row]
        cell.childLabel.text = kid.name


        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            kids.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    @IBAction func unwindToKidList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ConfirmKidViewController, kid = sourceViewController.kid {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing kid.
                kids[selectedIndexPath.row] = kid
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)

            } 
        }
        if let sourceViewController = sender.sourceViewController as? addKidViewController, kid = sourceViewController.kid {
            print("here")
                // Add a new kid.
                let newIndexPath = NSIndexPath(forRow: kids.count, inSection: 0)
                kids.append(kid)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        
    }

    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showConfirmKid"{
            if let selectedKid = sender as? kidListTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedKid)!
                let selectedKid = kids[indexPath.row]
                if selectedKid.isConfirmed {
                    performSegueWithIdentifier("showKidDetails", sender: selectedKid)
                    return false
                }
            }
        }
        return true
    }

    // TODO: add a segue to the confirm kid page if the kid.isConfirmed == false
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
        if segue.identifier == "showConfirmKid" {
            let confirmViewController = segue.destinationViewController as! ConfirmKidViewController

            // Get the cell that generated this segue.
            if let selectedKid = sender as? kidListTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedKid)!
                let selectedKid = kids[indexPath.row]
                if selectedKid.isConfirmed {
                    performSegueWithIdentifier("showKidDetails", sender: selectedKid)
                    
                }
                confirmViewController.kid = selectedKid
                
            }
        }
        
        if segue.identifier == "showKidDetails" {
            let routesViewController = segue.destinationViewController as! kidDetails
            
            // Get the cell that generated this segue.
            if let selectedKid = sender as? Kid {
                routesViewController.kid = selectedKid
            }
        }
    }
    
    
    

    
}
