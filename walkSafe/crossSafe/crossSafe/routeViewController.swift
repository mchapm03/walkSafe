//
//  routeViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/10/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit
import MapKit

class routeViewController: UIViewController {

    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var kid : Kid?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let kid = kid {
            navigationItem.title = kid.name
        }
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
