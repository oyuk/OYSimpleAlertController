//
//  ViewController.swift
//  OYSimpleAlertController
//
//  Created by oyuk on 09/20/2015.
//  Copyright (c) 2015 oyuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let alertTileColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
    let message =  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, "
    let message2 = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,"
    
    @IBAction func showOneButtonAlert(sender: AnyObject) {
        let alert = OYSimpleAlertController(title: "Title", message: message2)
        
        let defaultAction = OYAlertAction(title: "OK", actionStyle: .Default, actionHandler: {
            print("OK")
        })
        
        alert.addAction(defaultAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func showTwoButtonAlert(sender: AnyObject) {
        let alert = OYSimpleAlertController(title: "Title", message: message)
        
        let defaultAction = OYAlertAction(title: "OK", actionStyle: .Default, actionHandler: {
            print("OK")
        })
        
        let cancelAction = OYAlertAction(title: "Cancel", actionStyle: .Cancel, actionHandler: {
            print("Cancel")
        })
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

}

