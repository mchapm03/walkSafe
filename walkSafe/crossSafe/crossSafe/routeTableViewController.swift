//
//  routeTableViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/14/16.
//  Copyright © 2016 Tufts. All rights reserved.
//



import UIKit

class routeTableViewController: UITableViewController {
        
        var routes = [Route]()
        var kid : Kid?
    
        // MARK: - Table view data source
    
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "routeTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! routeTableViewCell
            
            let route = routes[indexPath.row]
            cell.routeTitle.text = route.date.description
            
            
            return cell
        }
        
        
        
        // Override to support conditional editing of the table view.
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }

        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
            if segue.identifier == "ShowRoute" {
                let routesVC = segue.destinationViewController as! routeViewController
                
                // Get the cell that generated this segue.
                if let selectedRoute = sender as? routeTableViewCell {
                    let indexPath = tableView.indexPathForCell(selectedRoute)!
                    let selectedRoute = routes[indexPath.row]
                    routesVC.route = selectedRoute
                }
            }
        }
        
        
        
        
        
}
