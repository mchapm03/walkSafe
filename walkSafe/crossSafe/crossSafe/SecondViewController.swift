//
//  ViewController.swift
//  Walk Safe
//
import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var foundDash: UILabel!
    @IBOutlet weak var NumberOfStreetCrossed: UILabel!

    @IBOutlet weak var NumberOfDetectedIntersection: UILabel!
    @IBOutlet weak var addressDisp: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
    var placemark: CLPlacemark!
    var FLAG_recording = 0;
    var IntersectionForServer:[[Double]] = []
    var StreetForServer:[[Double]] = []
    var AddressBook:[String] = []
    var State: Int!;
    var FirstState = 1;
    var date = NSDate()
    
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
        locationManager.requestAlwaysAuthorization()
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
        var myl2 = [[Double]]()
        for location in mylocations {
            let thisl = [Double(location.latitude), Double(location.longitude)]
            myl2 += [thisl]
        }
        // Save to server
        
        // params: childID, routeID, polylines, intersectX, streetX
        if let url = NSURL(string: "https://walk-safe.herokuapp.com/addRoute"){
            let session = NSURLSession.sharedSession() // use to get data
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            let intersectX = IntersectionForServer
            let streetX = StreetForServer
            let paramString = "childID=" + UIDevice.currentDevice().identifierForVendor!.UUIDString + "&routeID=" + String(date.timeIntervalSince1970) + "&polylines=" + myl2.description + "&intersectX=" + intersectX.description + "&streetX=" + streetX.description
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
        AddressBook = []
        StreetForServer = []
    }
  
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
                
                if(intersecAdd!.count > 2){
                    let c = [intersecAdd?[0] as! String, intersecAdd?[1] as! String,intersecAdd?[2] as! String]
                    self.addressDisp.text = c.joinWithSeparator(", ")
                    self.foundDash.text = "Not in intersection"
                }
                
                // Identify Intersections
                if self.addressDisp.text!.containsString("–") {
                    self.foundDash.text = "found intersection"
                    
                    //compare the CLLocation of the current intersection with previous identified intersections, if they are they same, then do not add to new intersection list
                    let tempLoc = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                    if(self.IntersectionDataCLL.count < 1){
                        //the first address with dash is always added to ensure that the app dont crash because of index out of bound
                        self.IntersectionDataCLL.append(tempLoc)
                        self.IntersectionForServer.append([tempLoc.coordinate.latitude, tempLoc.coordinate.longitude])
                        self.AddressBook.append(self.addressDisp.text!)
                    }else{
                        
                        //First condition
                        //If the new intersection is farther than 30 meters away, then it's a new one
                        if(self.IntersectionDataCLL[ self.IntersectionDataCLL.endIndex-1].distanceFromLocation(tempLoc) > 30){
                            //Second condition: the address(with dash) has to be a new one in the address book
                            if(self.AddressBook.contains(self.addressDisp.text!)){
                            }else{
                                self.foundDash.text = "NewIntersectionFound"
                                self.IntersectionDataCLL.append(tempLoc)
                                self.AddressBook.append(self.addressDisp.text!)
                                
                                self.IntersectionForServer.append([tempLoc.coordinate.latitude, tempLoc.coordinate.longitude])
                                self.NumberOfDetectedIntersection.text = String(self.IntersectionForServer.count)
                                self.FirstState = 1
                            }
                        }
                    }
                }else{
                    //if no dash found, check current state is either even or odd
                    // determine address parity
                    
                    
                    //read to space, store number for parity checking
                    let fullNameAdd = self.addressDisp.text!.characters.split{$0 == " "}.map(String.init)
                    
                    //If first string of Address line contains numbers, then we count the crossing
                    if var currState = Int(fullNameAdd[0]){
                        currState = currState%2
                        
                        if(self.FirstState == 1){
                            //set state based on street parity
                            //set FirstState to 0
                            self.State = currState
                            self.FirstState = 0
                        }
                        if(self.State == 0){
                            self.evenState(currState)
                            //When State is even --> call evenState with parameter of current address
                            //   - checks parity of current address.
                            //      a) if even - do nothing
                            //      b) if odd - call crossStreet function, set State to odd
                            
                        }else{
                            self.oddState(currState)
                            //If State is odd --> call oddState with parameter of current address
                            //   - check parity of current address
                            //     a) if even - call crossStreet function set State to even
                            //     b) if odd - do nothing
                        }
                        // crossStreet function - put down a marker at current coords, add pointto streets crossed array
                    }
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func evenState(parity: Int){
        if (parity == 1){
            //if parity is odd
            self.State = parity;
            crossStreet()
        }
    }
    
    func oddState(parity: Int){
        if (parity == 0){
            //if parity is even
            self.State = parity;
            crossStreet()
        }
    }
    
    func crossStreet(){
        //add info into data structure
        self.StreetForServer += [[self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude]]
        self.NumberOfStreetCrossed.text = String( self.StreetForServer.count)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {

        case .Authorized, .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        default: break
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    func locationManager( locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if (FLAG_recording == 1) {
            let cllc2d1 = mapView.userLocation.coordinate;
            
            if (cllc2d1.longitude != 0.0 && cllc2d1.latitude != 0.0){
                mylocations.append(mapView.userLocation.coordinate)
                
            }
            
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

