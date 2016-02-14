//
//  addKidViewController.swift
//  crossSafe
//
//  Created by Margaret Chapman on 2/10/16.
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit
import Foundation

class addKidViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addKidTitle: UILabel!
    @IBOutlet weak var kidPhoneInput: UITextField!
    @IBOutlet weak var kidNameInput: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var kid: Kid?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kidNameInput.delegate = self
        kidPhoneInput.delegate = self
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidInput()

    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        navigationItem.title = kidNameInput.text
        saveButton.enabled=true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidInput() {
        let text = kidNameInput.text ?? ""
        //let num = kidPhoneInput.text ?? ""
       // let toint = Int(num.stringByReplacingOccurrencesOfString("-", withString: ""))
        saveButton.enabled = !(text.isEmpty)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = kidNameInput.text ?? ""
            var phone = kidPhoneInput.text ?? ""
            phone = phone.stringByReplacingOccurrencesOfString("-", withString: "")
            kid = Kid(name: name, phone: Int(phone))
        }
    }

}
