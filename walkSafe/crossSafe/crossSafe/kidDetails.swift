//
//  kidDetails.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/14/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit

class kidDetails: UIViewController {
    
    @IBOutlet weak var phoneNumber: UILabel!
    var kid : Kid?
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