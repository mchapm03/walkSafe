//
//  ConfirmKidViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/15/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit
import Foundation

class ConfirmKidViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var codeInput: UITextField!

    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var newCodeButton: UIButton!
    
    var kid: Kid?
    
    override func viewDidAppear(animated: Bool) {
        if let kid = self.kid {
            if kid.isConfirmed {
                performSegueWithIdentifier("showKidDetails", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        codeInput.delegate = self
        
        // Enable the Save button only if the text field has valid input.
        checkValidInput()
        
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        submitButton.enabled=true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        submitButton.enabled = false
    }
    
    func checkValidInput() {
        let text = codeInput.text ?? ""
        if Int(text) != nil {
            submitButton.enabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if identifier == "showKidDetails"{
//            if let kid = self.kid {
//                if !kid.isConfirmed {
//                    return false
//                }else{
//                    return true
//                }
//            }
//        }
//        return true
//    }
    // confirm the kid
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if submitButton === sender {
            let text = codeInput.text ?? ""
            if kid != nil{
                kid?.confirmKid(Int(text))
            }
        }
        if segue.identifier == "showKidDetails" {
            //let kidDetailVC = segue.destinationViewController as! kidDetails
            let nav = segue.destinationViewController as! UINavigationController
            let kidDetailVC = nav.topViewController as! kidDetails
            // Get the cell that generated this segue.
            if let selectedKid = kid {
                kidDetailVC.kid = selectedKid
            }
        }
       
    }
    
}
