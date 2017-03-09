//
//  PostMoment.swift
//  MomentPost
//
//  Created by Admin on 7/5/16.
//  Copyright © 2016 Chenggang Xu. All rights reserved.
//

import UIKit

protocol PostMomentDelegate {
    func didSaveMoment(momentContent: String)
}

class PostMoment: UIViewController {
    
    @IBOutlet weak var momentContent: UITextView!
    var delegate: PostMomentDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let pref: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = pref.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1 ){
            let alertController = UIAlertController(title: "Error",
                                                    message: "Please sign in first",
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertActionStyle.Cancel, handler: {(_)in
                                            self.performSegueWithIdentifier("HomeView", sender: self)
            })
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true,
                                  completion: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelMoment(sender: AnyObject) {
        momentContent.text = ""
        self.performSegueWithIdentifier("HomeView", sender: sender)
    }
    
    @IBAction func postMoment(sender: AnyObject) {
        //self.delegate = MasterViewController()
        //self.delegate.insertNewMoment()
        //self.delegate?.didSaveMoment(momentContent.text)
        
        let splitViewController = self.tabBarController!.viewControllers![0] as! UISplitViewController
        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let controller = masterNavigationController.topViewController as! MasterViewController
        
        if(momentContent.text!.isEmpty){
            let alertController = UIAlertController(title: "Error",
                                                    message: "Can't post empty information",
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true,
                                  completion: nil)
        }else{
            controller.didSaveMoment(momentContent.text)
            momentContent.text = ""
            self.performSegueWithIdentifier("HomeView", sender: sender)
        }
    }
    
}
