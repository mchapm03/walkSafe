//
//  kidConnectViewController.swift
//  crossSafe
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
    
    // Add the kid to the db, and associate with uuid
    @IBAction func submit(sender: AnyObject) {
        // check that name is not null:
        if kidName.text == "" {
            self.errorLabel.text = "Please Enter a Name."
        }
        else {
            let name = kidName.text
            if name != "" {
                // set the defaults in the phone so that the kid does not have to enter the next time
                defaults.setObject(name, forKey: "MyName")
                
                // send name and uuid to heroku
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
    // After kid enters their name, send them to the routeViewController so they can start a walk
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "goStartWalk" {
             if kidName.text == "" {
                    return false
            }
        }
        return true
    }
    
}
