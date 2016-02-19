//
//  childViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/9/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class childViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var startWalk: UIButton!
    var mapView: MKMapView! = MKMapView()
    var coords = [CLLocationCoordinate2D]()
    var polyline: MKPolyline?
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        
        // Get my location
        // TODO: make sure view animation is complete
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.requestLocation()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 400 // in meters
            self.locationManager.headingFilter = kCLHeadingFilterNone
            self.locationManager.startUpdatingLocation()
        }
        else {
            let alert = UIAlertController(title: "Location Service Disabled", message: "Sorry, your location could not be determined!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //mapView.setUserTrackingMode(.Follow, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    @IBAction func startWalk(sender: AnyObject) {
        if self.startWalk.titleForState(.Normal) == "Start Walk" {
            self.startWalk.setTitle("Stop Walk", forState: .Normal)
        }else {
            self.startWalk.setTitle("Start Walk", forState: .Normal)
            savePolyline()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.startWalk.titleForState(.Normal) == "Stop Walk:"{
            coords += [locationManager.location!.coordinate]
        }
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alert = UIAlertController(title: "Location Service Failed", message: "Sorry, your location could not be determined!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//    func createTestPolyLine(){
//        let locations = [
//            CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude),
//            //            CLLocation(latitude: 32.7767, longitude: -96.7970),         /* San Francisco, CA */
//            //            CLLocation(latitude: 37.7833, longitude: -122.4167),        /* Dallas, TX */
//            //            CLLocation(latitude: 42.2814, longitude: -83.7483),         /* Ann Arbor, MI */
//            //            CLLocation(latitude: 32.7767, longitude: -96.7970),          /* San Francisco, CA */
//            CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude),
//        ]
    
//        var coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
//            return location.coordinate
//        })
//        
//        polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        
//    }
    
    func savePolyline() {
        // TODO: send polyline to heroku with uuid
        polyline = MKPolyline(coordinates: &coords, count: coords.count)
        //reset coords:
        coords = [CLLocationCoordinate2D]()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("preparing for segue")
    }
    

}
