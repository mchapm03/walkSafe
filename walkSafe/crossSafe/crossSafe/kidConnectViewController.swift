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
    

    @IBAction func submit(sender: AnyObject) {
        if kidName.text == "" {
            self.errorLabel.text = "Please Enter a Name."
        }else {
            let name = kidName.text
            if name != "" {
                
                defaults.setObject(name, forKey: "MyName")
                
                // TODO: send name and uuid to heroku
                if let url = NSURL(string: "https://walk-safe.herokuapp.com/addChild"){
                    let session = NSURLSession.sharedSession() // use to get data
                    let request = NSMutableURLRequest(URL: url)
                    request.HTTPMethod = "POST"
                    //request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
                    
                    let paramString = "childID=" + UIDevice.currentDevice().identifierForVendor!.UUIDString + "&parentID=&childName=" + name!
                    request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
                    let task = session.dataTaskWithRequest(request) {
                        (let data, let response, let error) -> Void in
                        
                        if error != nil {
                            print ("Whoops, something went wrong with the connections! Details: \(error!.localizedDescription); \(error!.userInfo)")
                        }
                        
                        if let httpResponse = response as? NSHTTPURLResponse {
                            if httpResponse.statusCode != 200 {
                                let alert = UIAlertController(title: "Account Creation Failed", message: "Sorry, your name could not be added!", preferredStyle: UIAlertControllerStyle.Alert)
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
            }
            
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "goStartWalk" {
             if kidName.text == "" {
                    return false
            }
        }
        return true
    }

    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//
//    }

    
    
}
