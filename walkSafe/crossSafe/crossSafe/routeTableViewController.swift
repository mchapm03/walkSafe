//
//  routeTableViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/14/16.
//  Copyright © 2016 Tufts. All rights reserved.
//



import UIKit
import Foundation

class routeTableViewController: UITableViewController {
        
        var routes = [Route]()
        var kid : Kid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let kid = kid {
            navigationItem.title = kid.name + "'s Routes"
        }

        loadRoutes()
    }
    func loadRoutes() {
        if kid != nil {
            if kid?.routes != nil{
                self.routes = (kid?.routes)!
            }
            //TODO: load routeIDs and find all in database:
            if kid?.routeIDs != nil{
                print("kid ids: \(kid?.routeIDs)")

            }
        }
    }
    
        // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (kid?.routeIDs.count)!
        //return routes.count
    }
    
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "routeTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! routeTableViewCell
            // TODO: show the route date in a "normal/redable" format
//            let route = routes[indexPath.row]
            let route = kid?.routeIDs[indexPath.row]
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let convertedDate = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: route!))
            cell.routeTitle.text = convertedDate
            
            return cell
        }

    // Override to support conditional editing of the table view.
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            // Don't allow users to edit route list
            return false
        }

        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
            if segue.identifier == "ShowRoute" {
                let routesVC = segue.destinationViewController as! routeViewController
                // Get the cell that generated this segue.
                if let selectedRoute = sender as? routeTableViewCell {
                    let indexPath = tableView.indexPathForCell(selectedRoute)!
                    //let selectedRoute = routes[indexPath.row]
                    let selectedRoute = kid?.routeIDs[indexPath.row]
                    // Set the route to the one that the user selected.
                    routesVC.route = selectedRoute
                }
            }
        }
         
        
}
