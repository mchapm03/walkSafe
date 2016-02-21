//
//  kidListTableViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/10/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class kidListTableViewController: UITableViewController {
    
    var kids = [Kid]()
    var routeIDs = [Double]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved kids, otherwise load sample data.
        if let savedKids = loadKids() {
            kids += savedKids
        }else{
            loadSampleKids()
        }
    }
    // TODO: load real kids and their views. Incorporate NSData and Heroku server
    func loadSampleKids() {
        kids += [Kid(name: "Johnny", phone: 8903873728)!]
        let kid1 = Kid(name: "Suzy")
        kid1?.isConfirmed = true
        kid1?.routes = [Route(time:NSDate()), Route(time: NSDate(timeIntervalSinceNow: 398398))]
        kids += [kid1!]
    }
    func loadSampleRoute() -> Route {
        let date = NSDate(timeIntervalSince1970:(Double(String(NSDate().timeIntervalSince1970)))!)
        let inter: [CLLocationCoordinate2D] = []
        let strt: [CLLocationCoordinate2D] = []
        let polyline = [(30, -70), (30.11,-69.88),(30.2,-69.80)]
        var p2 = polyline.map({ (lat: Double, long: Double) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: lat, longitude: long)})
        let route1 = Route(time: date)
        route1.routeCoords = MKPolyline(coordinates: &p2, count: polyline.count)
        route1.intersectX = inter
        route1.streetX = strt
        return route1
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
            saveKid()
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
                // Add a new kid.
                let newIndexPath = NSIndexPath(forRow: kids.count, inSection: 0)
                kids.append(kid)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        
        saveKid()
        
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
    
    
    //MARK: NSCoding
    
    func saveKid() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(kids, toFile: Kid.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save kids...")
        }
    }
    
    func loadKids() -> [Kid]? {
        // Get kids from nscoder stored data
        let myKids = NSKeyedUnarchiver.unarchiveObjectWithFile(Kid.ArchiveURL.path!) as? [Kid]
        for kid in (myKids)!{
            if kid.name == "Maggie"{
            if let url = NSURL(string: "https://walk-safe.herokuapp.com/getChildRoutes"){
                let session = NSURLSession.sharedSession() // use to get data
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                //send parent id and child name
                let paramString = "parentID=" + "&childName=" + kid.name
                print(paramString)
                request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
                let task = session.dataTaskWithRequest(request) {
                    (let data, let response, let error) -> Void in
                    
                    if error != nil {
                        print ("Whoops, something went wrong with the connections! Details: \(error!.localizedDescription); \(error!.userInfo)")
                    }
//                    if let httpResponse = response as? NSHTTPURLResponse {
//                        print(httpResponse.description)
//
//                        if httpResponse.statusCode != 200 {
//                            let alert = UIAlertController(title: "Account Creation Failed", message: "Sorry, your name could not be added!", preferredStyle: UIAlertControllerStyle.Alert)
//                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//                            self.presentViewController(alert, animated: true, completion: nil)
//                        }
//                    }else{
//                        print("other error")
//                    }

                    if data != nil {
                        do{
                            let raw = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)

                            if let json = raw as? [[String: AnyObject]] {
                                for entry in json {
                                    if let entries = entry["routes"] as? [String]{
                                        for e in entries{
                                            self.routeIDs += [Double(e)!]
                                            kid.routeIDs += [Double(e)!]
                                        }
                                    }
                                   // kid.routeIDs = self.
                                    print("entries: \(kid.routeIDs)")
                                }
                            }
                        }
                        catch{ //If not json type data
                            // If child not in db
                            print("not json")
                            kid.routes += [self.loadSampleRoute()]
                            
                        }
                    }
                }
                task.resume() //sending request
            }
        }
        }
        return myKids
    }

    
}
