//
//  newTicker.swift
//  Stock Decisions
//
//  Created by Andrew Lee on 9/2/15.
//  Copyright (c) 2015 Andrew Lee. All rights reserved.
//

import UIKit

class newTicker: UIViewController, UITextFieldDelegate {

//    @IBOutlet weak var newChoice: UITextField!
    @IBOutlet weak var newChoice: UITextField!
    var choice: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newChoice.becomeFirstResponder()
        // Assign newChoice as it's own delegate
        newChoice.delegate=self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Sending new object from newCells to NewCustomController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "doneSegue" {
            choice = newChoice.text!
            NSLog("%@ was passed at least", choice)
        }
        
    }
    
    // Dismisses the keyboard if enter is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    // Dismisses the keyboard if touched anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        if let touch = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
    
}
