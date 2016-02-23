//
//  ViewController.swift
//  crossSafe
//

import UIKit
import Foundation

class ViewController: UIViewController {


    @IBOutlet weak var openingLabel: UILabel!
    @IBOutlet weak var studentLabel: UIButton!
    @IBOutlet weak var parentLabel: UIButton!
    // save kid name so they only have to enter the first time they use the app
    let defaults = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        //reset kid name for class demo:
//        defaults.removeObjectForKey("MyName")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func studentPressed(sender: AnyObject) {
        //handle segues elsewheree
   }
    
    // if kid -> if already confirmed: "showStartRoute" segue else "getKidName" segue
    // if parent -> load all kids associated with this person
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
        
    }

}

