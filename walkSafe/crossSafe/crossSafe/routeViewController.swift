//
//  routeViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/10/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit
import MapKit

class routeViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var goodCross: UILabel!
    @IBOutlet weak var badCross: UILabel!
    @IBOutlet weak var pieGraphView: PieGraphView!
    var route: Route?
    //var route: Double?
    var coords = [CLLocationCoordinate2D]()
    var poly : MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let r = route {
            pieGraphView.goodCross = (r.intersectX?.count)!
            pieGraphView.badCross = (r.streetX?.count)!
        }
            
        goodCross.text = "Good Crossings: \(pieGraphView.goodCross)"
        badCross.text = "Bad Crossings: \(pieGraphView.badCross)"
        
        if self.coords.count != 0 {
            self.updatepolyline()
        }
        
        //loadSampleRoute()
        if let route = self.route {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            //let convertedDate = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: route))
            let convertedDate = dateFormatter.stringFromDate(route.date)
            routeLabel.text = convertedDate
            print("intersection count: \(route.intersectX?.count)")
            print("street count: \(route.streetX?.count)")

            self.poly = route.routeCoords
            updatepolyline()
//            var c1 = [CLLocationCoordinate2D]()
            // TODO: get route from db:
//            if let url = NSURL(string: "https://walk-safe.herokuapp.com/getRouteDetails"){
//                let session = NSURLSession.sharedSession() // use to get data
//                let request = NSMutableURLRequest(URL: url)
//                request.HTTPMethod = "POST"
//                let paramString = "routeID=\(route)"
//                print("route id: " + paramString)
//                request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
//                let task = session.dataTaskWithRequest(request) {
//                    (let data, let response, let error) -> Void in
//                    
//                    if error != nil {
//                        print ("Whoops, something went wrong with the connections! Details: \(error!.localizedDescription); \(error!.userInfo)")
//                    }
//                    
//                    if data != nil {
//                        do{
//                            let raw = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
//                            
//                            if let json = raw as? [[String: AnyObject]] {
//                               // print("in json")
//                                for entry in json {
//                                    //print("in entry: \(entry["polylines"]!)")
//                                    if let e1 = entry["polylines"] as? String {
//                                        do{
//                                            let r1 = try NSJSONSerialization.JSONObjectWithData(e1.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers)
//                                                if let j1 = r1 as? [[Double]] {
//                                                    for cord in j1{
//                                                        c1 += [CLLocationCoordinate2D(latitude: cord[0], longitude: cord[1])]
//                                                    }
//                                                }
//                                            self.coords = c1
////                                            self.updatepolyline()
//                                            
//                                        }
//                                        catch {
//                                            print("other obj")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        catch{ //If not json type data
//                            // If route not in db
//                            print("not route")
//                        }
//                    }
//                }
//                task.resume() //sending request
//                
//            }

        }

    }
    
    func updatepolyline() {
        //self.poly = MKPolyline(coordinates: &coords, count: coords.count)
        //print(coords.count)
        
        //   self.poly = MKPolyline(coordinates: &self.coords, count: self.coords.count)
        
        let l2 = self.poly!.boundingMapRect
        // Set zoom on map
        self.mapView.setVisibleMapRect(l2, animated: true)
        self.mapView.addOverlay((self.poly)!)
    }
    // TODO: load real route
    func loadSampleRoute() {
        //var path = [CLLocationCoordinate2D(latitude: 42.408164, longitude: -71.116010), CLLocationCoordinate2D(latitude: 42.410722, longitude: -71.120762), CLLocationCoordinate2D(latitude: 42.404796, longitude: -71.122660)]
        //self.route = Route(route: MKPolyline(coordinates: &path, count: path.count))
    }
    
    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay);
            pr.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5);
            pr.lineWidth = 5;
            return pr;
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
