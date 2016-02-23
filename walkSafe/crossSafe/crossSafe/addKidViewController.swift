//
//  addKidViewController.swift
//  crossSafe
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
        
        // Enable the Save button only if the text field has a valid input
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
    
    // Go back to the kid list, and add the new kid to the parent's kid list
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = kidNameInput.text ?? ""
            var phone = kidPhoneInput.text ?? ""
            phone = phone.stringByReplacingOccurrencesOfString("-", withString: "")
            kid = Kid(name: name, phone: Int(phone))
        }
    }

}
