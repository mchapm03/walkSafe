//
//  routeViewController.swift
//  crossSafe
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
    var color = UIColor.greenColor().colorWithAlphaComponent(0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let r = route {
            pieGraphView.goodCross = (r.intersectX?.count)!
            pieGraphView.badCross = (r.streetX?.count)!
            for inter in r.intersectX! {
                self.mapView.addOverlay(MKCircle(centerCoordinate: inter, radius: CLLocationDistance(5)))
            }
            color = UIColor.redColor().colorWithAlphaComponent(0.5)
            for st in r.streetX! {
                self.mapView.addOverlay(MKCircle(centerCoordinate: st, radius: CLLocationDistance(5)))
            }
        }
            
        goodCross.text = "Good Crossings: \(pieGraphView.goodCross)"
        badCross.text = "Bad Crossings: \(pieGraphView.badCross)"
        
        if self.coords.count != 0 {
            self.updatepolyline()
        }
        
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


        }

    }
    
    func updatepolyline() {
        
        let l2 = self.poly!.boundingMapRect
        // Set zoom on map
        self.mapView.setVisibleMapRect(l2, animated: true)
        self.mapView.addOverlay((self.poly)!)
    }
    
    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay);
            pr.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5);
            pr.lineWidth = 5;
            return pr;
        } else if overlay is MKCircle {
            let cr = MKCircleRenderer(overlay: overlay)
            cr.strokeColor = color
            cr.lineWidth = 10;
            return cr;
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
