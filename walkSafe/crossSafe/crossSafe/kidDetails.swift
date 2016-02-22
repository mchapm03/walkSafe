//
//  kidDetails.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/14/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit

class kidDetails: UIViewController {
    
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var overallGraphView: OverallGraphView!
    @IBOutlet weak var phoneNumber: UILabel!
    var kid : Kid?
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
        loadSampleRoutes()
        
        setupGraphDisplay()
    }
    // TODO: load kid stats from heroku and create graphics for them
    
    
    
    // TODO: load these from heroku
    func loadSampleRoutes() {
        routes += [Route(time:NSDate())]
        routes += [Route(time:NSDate(timeIntervalSinceNow: 78939))]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showKidRoutes" {
            //let nav = segue.destinationViewController as! UINavigationController
            //let routesTVC = nav.topViewController as! routeTableViewController
            let routesTVC = segue.destinationViewController as! routeTableViewController
            // Get the cell that generated this segue.
            if let currentKid = kid {
                print(currentKid.name)
                routesTVC.kid = currentKid
            }
        }
    }
    
    func setupGraphDisplay() {
        if let maxPoint = overallGraphView.graphPoints.maxElement() {
            maxLabel.text = "\(maxPoint)"
        }
        else {
            maxLabel.text = ""
        }
    }
}