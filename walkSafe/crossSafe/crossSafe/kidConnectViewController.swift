//
//  kidConnectViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/18/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit

class kidConnectViewController: UIViewController {
    
    @IBOutlet weak var submitBut: UIButton!
    @IBOutlet weak var kidName: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "goStartWalk" {
            if kidName.text == "" {
                self.errorLabel.text = "Please Enter a Name."
                print("here")
                return false
            }
        }
        return true
    }
    //TODO: upload the kid name with uuid to the heroku server
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goStartWalk" {
            let name = kidName.text
            if name != "" {
                print("got name")
                defaults.setObject(name, forKey: "MyName")
                // TODO: send name and uuid to heroku
                //performSegueWithIdentifier("goStartWalk", sender: self)
            } else {
                print("in else")
            }
        }
    }

    
    
}
