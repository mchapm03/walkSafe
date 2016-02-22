//
//  routeTableViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/14/16.
//  Copyright © 2016 Tufts. All rights reserved.
//



import UIKit
import Foundation
import CoreLocation
import MapKit

class routeTableViewController: UITableViewController {
        
        var routes = [Route]()
        var kid : Kid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kid?.routes = routes
        if let kid = kid {
            navigationItem.title = kid.name + "'s Routes"
        }

        loadRoutes()
    }
    func loadRoutes() {
        if kid != nil {
//            if kid?.routes != nil{
//                self.routes = (kid?.routes)!
//            }
            //TODO: load routeIDs and find all in database:
//            if kid?.routeIDs != nil{
                print("kid ids: \(kid?.routeIDs)")
                for id in (kid?.routeIDs)! {
                    // TODO: get route from db:
//                    print("\(id)")
                    var c1 = [CLLocationCoordinate2D]()
                    var i1 = [CLLocationCoordinate2D]()
                    var s1 = [CLLocationCoordinate2D]()
                    if let url = NSURL(string: "https://walk-safe.herokuapp.com/getRouteDetails"){
                        let session = NSURLSession.sharedSession() // use to get data
                        let request = NSMutableURLRequest(URL: url)
                        request.HTTPMethod = "POST"
                        let paramString = "routeID=\(id)"
                        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
                        let task = session.dataTaskWithRequest(request) {
                            (let data, let response, let error) -> Void in
                            
                            if error != nil {
                                print ("Whoops, something went wrong with the connections! Details: \(error!.localizedDescription); \(error!.userInfo)")
                            }
                            
                            if data != nil {
                                do{
                                    let raw = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                                    
                                    if let json = raw as? [[String: AnyObject]] {
                                        for entry in json {
//                                            print("in entry: \(entry["polylines"]!)")
                                            var thisroute : Route
                                            if let routeid = entry["routeID"] as? String {
                                                thisroute = Route(time: NSDate(timeIntervalSince1970: Double(routeid)!))
                                                if let intersections = entry["intersectX"] as? String {
                                                    do{
                                                        let r1 = try NSJSONSerialization.JSONObjectWithData(intersections.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers)
                                                        if let j1 = r1 as? [[Double]] {
                                                            for cord in j1{
                                                                i1 += [CLLocationCoordinate2D(latitude: cord[0], longitude: cord[1])]
                                                            }
                                                        }
                                                        thisroute.intersectX = i1
                                                    }
                                                }
                                                
                                                if let streets = entry["streetX"] as? String {
                                                    do{
                                                        let r1 = try NSJSONSerialization.JSONObjectWithData(streets.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers)
                                                        if let j1 = r1 as? [[Double]] {
                                                            for cord in j1{
                                                                s1 += [CLLocationCoordinate2D(latitude: cord[0], longitude: cord[1])]
                                                            }
                                                        }
                                                        thisroute.streetX = s1
                                                    }
                                                }
                                            
                                            if let e1 = entry["polylines"] as? String {
                                                do{
                                                    let r1 = try NSJSONSerialization.JSONObjectWithData(e1.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers)
                                                    if let j1 = r1 as? [[Double]] {
                                                        for cord in j1{
                                                            c1 += [CLLocationCoordinate2D(latitude: cord[0], longitude: cord[1])]
                                                        }
                                                    }
                                                    thisroute.routeCoords = MKPolyline(coordinates: &c1, count: c1.count)
                                                    self.routes += [thisroute]
                                                    self.tableView.reloadData()
                                                    //routesVC.coords = c1
                                                }
                                                
                                                catch {
                                                    print("other obj")
                                                }
                                                }
                                            }
                                        }
                                    }
                                }
                                catch{ //If not json type data
                                    // If route not in db
                                    print("not route")
                                }
                            }
                        }
                        task.resume() //sending request
                        
                    }
                    
                }

//            }
        }
    }
    
        // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (kid?.routeIDs.count)!
        return routes.count
    }
    
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "routeTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! routeTableViewCell
            // TODO: show the route date in a "normal/redable" format
            let route = routes[indexPath.row]
//            let route = kid?.routeIDs[indexPath.row]
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            //let convertedDate = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: route!))
            let convertedDate = dateFormatter.stringFromDate(route.date)
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
                    let selectedRoute = routes[indexPath.row]
                    //let selectedRoute = kid?.routeIDs[indexPath.row]
                    
                    // Set the route to the one that the user selected.
                    routesVC.route = selectedRoute
                }
            }
        }
         
        
}
