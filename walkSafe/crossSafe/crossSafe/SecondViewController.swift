//
//  ViewController.swift
//  Walk Safe
//
//  Created by mac-p on 2/8/16.
//  Copyright © 2016 Tufts University. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var foundDash: UILabel!
    @IBOutlet weak var addressDisp: UILabel!
    @IBOutlet weak var NumberOfDetectedIntersection: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
    var placemark: CLPlacemark!
    var FLAG_recording = 0;
    var date = NSDate()
    var IntersectionForServer:[(Double,Double)] = []
    
    //    print(mapView.userLocation.coordinate)
    var IntersectionDataCLL: [CLLocation] = []
    var mylocations: [CLLocationCoordinate2D] = []
    var geoLocations: [String] = []
    let geocoder = CLGeocoder()
    @IBOutlet weak var Geocoderswtich: UIButton!
    
    //    var receiveLocation: CLLocation! = nil
    
    //    @IBOutlet weak var dropPin: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.addSubview(addressDisp)
        addressDisp.translatesAutoresizingMaskIntoConstraints=false
    }
    @IBAction func StartRecording(sender: AnyObject) {
        date = NSDate()
        FLAG_recording = 1
    }
    @IBAction func FinishRecording(sender: AnyObject) {
        FLAG_recording = 0
        let overlay = mapView.overlays
        mapView.removeOverlays(overlay)
        /*
        Need to send the information to the server
        */
        let myls = mylocations.map({CLLocationCoordinate2D -> (Double, Double) in
                                        (CLLocationCoordinate2D.latitude, CLLocationCoordinate2D.longitude)})
//        print("mylocations: \(myls)")
//        print("IntersectionDataForServer: \(IntersectionForServer)")

        
        
        // Save to server
        
        // params: childID, routeID, polylines, intersectX, streetX
        if let url = NSURL(string: "https://walk-safe.herokuapp.com/addRoute"){
            let session = NSURLSession.sharedSession() // use to get data
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            //request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            //                let childID = UIDevice.currentDevice().identifierForVendor!.UUIDString
            //                let routeID = date?.description
            let intersectX = IntersectionForServer
            // TODO
            let streetX = [[]]
            let paramString = "childID=" + UIDevice.currentDevice().identifierForVendor!.UUIDString + "&routeID=" + String(date.timeIntervalSince1970) + "&polylines=" + myls.description + "&intersectX=" + intersectX.description + "&streetX=" + streetX.description
            print(paramString)
            request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = session.dataTaskWithRequest(request) {
                (let data, let response, let error) -> Void in
                
                if error != nil {
                    print ("Whoops, something went wrong with the connections! Details: \(error!.localizedDescription); \(error!.userInfo)")
                }
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        let alert = UIAlertController(title: "Route Upload Failed", message: "Sorry, your walk could not be added!", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }else{
                    print("other error")
                }
                
            }
            task.resume() //sending request
        }
        else {
            print ("Whoops, something is wrong with the URL")
        }
        
        // Reset arrays
        mylocations=[]
        IntersectionDataCLL = []
        IntersectionForServer = []
    }
//    @IBAction func GeoCoderSwitch(sender: AnyObject) {
//
//        let location1 = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
//        
//        geocoder.reverseGeocodeLocation(location1, completionHandler: {(placemarks, error) -> Void in
//            
//            if error != nil {
//                print("Reverse geocoder failed with error" + error!.localizedDescription)
//                return
//            }
//            if placemarks!.count > 0 {
//                let pm = placemarks![0] as CLPlacemark
//                
//                let intersecAdd = pm.addressDictionary?["FormattedAddressLines"]
//                
//                let c = [intersecAdd?[0] as! String, intersecAdd?[1] as! String,intersecAdd?[2] as! String]
//                self.addressDisp.text = c.joinWithSeparator(", ")
////                print( "self.addressDisp.text:", self.addressDisp.text!)
//                self.foundDash.text = "Not in intersection"
//                if self.addressDisp.text!.containsString("–") {
//                    
//                    
//                    self.foundDash.text = "found intersection"
//                    let tempLoc = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
//                    if(self.IntersectionDataCLL.count < 1){
//                        self.IntersectionDataCLL.append(tempLoc)
//                    }else{
//                        if(self.IntersectionDataCLL[ self.IntersectionDataCLL.endIndex-1].distanceFromLocation(tempLoc) > 30){
//                            self.foundDash.text = "NewIntersectionFound"
//                            self.IntersectionDataCLL.append(tempLoc)
//                        }
//                    }
//                }
//            }
//            else {
//                print("Problem with the data received from geocoder")
//            }
//        })
//        
//    }
//    
    func findIntersection(){
        let location1 = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location1, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("In findIntersection(), Reverse geocoder failed with error " + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                
                
                let intersecAdd = pm.addressDictionary?["FormattedAddressLines"]
                if intersecAdd!.count > 2{

                    let c = [intersecAdd?[0] as! String, intersecAdd?[1] as! String,intersecAdd?[2] as! String]
                    self.addressDisp.text = c.joinWithSeparator(", ")
    //                print( "self.addressDisp.text:", self.addressDisp.text!)
                    self.foundDash.text = "Not in intersection"
                }
                // Identify Intersections
                if self.addressDisp.text!.containsString("–") {
                    self.foundDash.text = "found intersection"
                    
                    //compare the CLLocation of the current intersection with previous identified intersections, if they are they same, then do not add to new intersection list
                    let tempLoc = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                    if(self.IntersectionDataCLL.count < 1){
                        self.IntersectionDataCLL.append(tempLoc)
                        self.IntersectionForServer.append((tempLoc.coordinate.latitude, tempLoc.coordinate.longitude))
                    }else{
                        if(self.IntersectionDataCLL[ self.IntersectionDataCLL.endIndex-1].distanceFromLocation(tempLoc) > 30){
                            self.foundDash.text = "NewIntersectionFound"
                            self.IntersectionDataCLL.append(tempLoc)
                            self.IntersectionForServer.append((tempLoc.coordinate.latitude, tempLoc.coordinate.longitude))
                            print(self.IntersectionForServer)
                            self.NumberOfDetectedIntersection.text = String(self.IntersectionForServer.count)
                        }
                    }
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized, .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        default: break
        }
    }
    
    
    func locationManager( locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        
        if (FLAG_recording == 1) {
            let cllc2d1 = mapView.userLocation.coordinate;
            //        let cllc2d1CLL = CLLocation(latitude: cllc2d1.latitude, longitude: cllc2d1.longitude )
            if (cllc2d1.longitude != 0.0 && cllc2d1.latitude != 0.0){
                mylocations.append(mapView.userLocation.coordinate)
                
                //            IntersectionDataCLL.append(cllc2d1CLL)
            }
            //        print("after append", mylocations)
            
            //
            //        let spanX = 0.007
            //        let spanY = 0.007
            //        let newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
            //        mapView.setRegion(newRegion, animated: true)
            
            if (mylocations.count > 5){
                let sourceIndex = mylocations.count - 1
                let destinationIndex = mylocations.count - 2
                
                let c1 = mylocations[sourceIndex]
                let c2 = mylocations[destinationIndex]
                var a = [c1, c2]
                let polyline = MKPolyline(coordinates: &a, count: a.count)
                mapView.addOverlay(polyline)
                findIntersection()
            }
        }
    }
    
    func mapView( mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer{
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
}

