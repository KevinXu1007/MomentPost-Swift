//
//  SignUp.swift
//  MomentShare
//
//  Created by Chenggang Xu on 7/1/16.
//  Copyright © 2016 Chenggang Xu. All rights reserved.
//

import UIKit

protocol SignUpDelegate {
    func didSaveUser(content: [String])
}

class SignUp: UIViewController {
    
    @IBOutlet var inputFields: [UITextField]!
    var delegate: SignUpDelegate?
    
    // field names used in loops to get/set Contact attribute values via
    // NSManagedObject methods valueForKey and setValue
    private let fieldNames = ["email", "password", "confirm","phone", "firstname", "lastname"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backHome(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let splitViewController = storyboard.instantiateInitialViewController()!.childViewControllers[0] as! UISplitViewController
        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let controller = masterNavigationController.topViewController as! MasterViewController
        
        for i in 0..<fieldNames.count {
            if(inputFields[i].text!.isEmpty){
                let alertController = UIAlertController(title: "Error",
                                                        message: "\(fieldNames[i]) are required",
                                                        preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(okAction)
                presentViewController(alertController, animated: true,
                                      completion: nil)
                return
            }
        }
        
        if(controller.checkUserInfo(inputFields[0].text!) == true){
            let alertController = UIAlertController(title: "Error",
                                                    message: "\(fieldNames[0]) has exist!",
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true,
                                  completion: nil)
            return
        }
        
        if(inputFields[1].text != inputFields[2].text){
            let alertController = UIAlertController(title: "Error",
                                                    message: "password and confirm password is different",
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true,
                                  completion: nil)
        }else{
            var user = [String]()
            for i in 0..<fieldNames.count {
                if fieldNames[i] != "confirm"{
                    user.append(inputFields[i].text!)
                }
                
            }
            
            controller.didSaveUser(user)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

