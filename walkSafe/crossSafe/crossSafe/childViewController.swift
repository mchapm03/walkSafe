//
//  childViewController.swift
//  crossSafe
//
import UIKit
import MapKit
import CoreLocation


class childViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var startWalk: UIButton!
    //var mapView: MKMapView! = MKMapView()
    var coords = [CLLocationCoordinate2D]()
    var polyline: MKPolyline?
    var date : NSDate?
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            date = NSDate()
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
    
    func loadSampleIntersections() -> [CLLocationCoordinate2D]{
        var intersects = [CLLocationCoordinate2D]()
        intersects += [CLLocation(latitude: 32.7767, longitude: -96.7970).coordinate]
        intersects += [CLLocation(latitude: 31.445, longitude: -96.660).coordinate]
        return intersects
    }
    func loadSampleStreets() -> [CLLocationCoordinate2D]{
        var streets = [CLLocationCoordinate2D]()
        streets += [CLLocation(latitude: 42.2814, longitude: -83.7483).coordinate]
        streets += [CLLocation(latitude: 31.445, longitude: -96.660).coordinate]
        return streets
    }
    func savePolyline() {
        //  send polyline to heroku with uuid
        polyline = MKPolyline(coordinates: &coords, count: coords.count)
        
        
            // send route. childID, routeID, polylines, intersectX, streetX
            if let url = NSURL(string: "https://walk-safe.herokuapp.com/addRoute"){
                let session = NSURLSession.sharedSession() // use to get data
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                let intersectX = loadSampleIntersections()
                let streetX = loadSampleStreets()
                let paramString = "childID=" + UIDevice.currentDevice().identifierForVendor!.UUIDString + "&routeID=" + String(date?.timeIntervalSince1970) + "&polylines=" + coords.description + "&intersectX=" + intersectX.description + "&streetX=" + streetX.description
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

        //reset coords:
        coords = [CLLocationCoordinate2D]()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("preparing for segue")
    }
    

}
