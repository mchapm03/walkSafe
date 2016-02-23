//
//  kidDetails.swift
//  crossSafe
//

import UIKit
import MapKit
import CoreLocation

class kidDetails: UIViewController {
    // For graph:
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var overallGraphView: OverallGraphView!
    @IBOutlet weak var phoneNumber: UILabel!
    
    var kid : Kid?
    var good = [Int]()
    var bad = [Int]()
    var routes = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let kid = kid {
            navigationItem.title = kid.name
            if kid.phone != nil{
                phoneNumber.text = String(kid.phone!)
            }else{
                phoneNumber.text = ""
            }
        }
        loadRoutes()
        
        setupGraphDisplay()
    }
    
    
    func loadRoutes() {
        // load routes from database to get all the routes and stats for total streets/intersections over time
        
        kid?.routes = []
        for id in (kid?.routeIDs)! {
            // Use to keep track of returned values
            var c1 = [CLLocationCoordinate2D]()
            var i1 = [CLLocationCoordinate2D]()
            var s1 = [CLLocationCoordinate2D]()
            
            // params: routeID
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
                                                self.good += [i1.count]
                                                if i1.count > (Int(self.maxLabel.text!)) {
                                                    self.maxLabel.text = "\(i1.count)"
                                                }
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
                                                self.bad += [s1.count]
                                                if s1.count > (Int(self.maxLabel.text!)) {
                                                    self.maxLabel.text = "\(s1.count)"
                                                }
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
                                                self.kid?.routes += [thisroute]
                                            }
                                                
                                            catch {
                                                print("other obj")
                                            }
                                        }
                                    }
                                }
                            }
                            // Update graph with this kid's data
                            // TODO: figure out why loading is so slow
                            self.overallGraphView.graphPoints = self.good
                            self.overallGraphView.graphPointsBad = self.bad
                            self.overallGraphView.setNeedsDisplay()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    // go to route table list with this kid's routes listed:
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showKidRoutes" {
            
            let routesTVC = segue.destinationViewController as! routeTableViewController
            // Get the cell that generated this segue.
            if let currentKid = kid {
                print(currentKid.name)
                routesTVC.kid = currentKid
            }
        }
    }
    
    // create line graph view
    func setupGraphDisplay() {
        if let maxPoint = overallGraphView.graphPoints.maxElement() {
            if maxPoint > overallGraphView.graphPointsBad.maxElement(){
                maxLabel.text = "\(maxPoint)"
            }
            maxLabel.text = "\(overallGraphView.graphPointsBad.maxElement()!)"
        }
        else {
            maxLabel.text = ""
        }
    }
}