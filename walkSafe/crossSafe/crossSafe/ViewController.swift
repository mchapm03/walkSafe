//
//  ViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/9/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {


    @IBOutlet weak var openingLabel: UILabel!
    @IBOutlet weak var studentLabel: UIButton!
    @IBOutlet weak var parentLabel: UIButton!
    let defaults = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
//        defaults.removeObjectForKey("MyName")
//        print((NSUserDefaults.standardUserDefaults().objectForKey("MyName") as! String))
//        print(UIDevice.currentDevice().identifierForVendor!.UUIDString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // TODO: decide if the phone is in the db 
    // if kid -> if already confirmed: "showStartRoute" segue else "getKidName" segue
    // if parent -> load all kids associated with this person
    
    @IBAction func studentPressed(sender: AnyObject) {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if defaults.objectForKey("MyName") as? String != nil {
//            performSegueWithIdentifier("showStartWalk", sender: self)
//        } else {
//            performSegueWithIdentifier("getKidName", sender: self)
//        }
   }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "getKidName"{
            if defaults.objectForKey("MyName") as? String != nil {
                performSegueWithIdentifier("showStartRoute", sender: self)
                return false
            }
        }
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "getKidName"{
//            if defaults.objectForKey("MyName") as? String != nil {
//                performSegueWithIdentifier("showStartRoute", sender: self)
//            } else {
//                //performSegueWithIdentifier("getKidName", sender: self)
//            }
//        }
        
    }

}

