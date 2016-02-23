//
//  route.swift
//  crossSafe
//

import UIKit
import Foundation
import MapKit
import CoreLocation

class Route {
    var date: NSDate
    var intersectX: [CLLocationCoordinate2D]?
    var streetX: [CLLocationCoordinate2D]?
    var totalIntersections: Int?
    var greenIntersections: Int?
    var yellowIntersections: Int?
    var redIntersections: Int?
    var routeCoords: MKPolyline?
    
    init(time: NSDate){
        self.date = time
        //self.routeCoords = routeCoords
    }
    init(route: MKPolyline) {
        self.routeCoords = route
        self.date = NSDate()
    }
}