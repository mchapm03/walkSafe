//
//  route.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/14/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class Route {
    var date: NSDate
    var totalIntersections: Int?
    var greenIntersections: Int?
    var yellowIntersections: Int?
    var redIntersections: Int?
    var routeCoords: MKPolyline
    
    init(time: NSDate, routeCoords: MKPolyline){
        self.date = time
        self.routeCoords = routeCoords
    }
}