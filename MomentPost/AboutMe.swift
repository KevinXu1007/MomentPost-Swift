//
//  AboutMe.swift
//  MomentShare
//
//  Created by Chenggang Xu on 7/4/16.
//  Copyright © 2016 Chenggang Xu. All rights reserved.
//

import UIKit

protocol AboutMeDelegate {
    func getUserInfo(content: String)->UserInfo
}

class AboutMe: UIViewController {
    
    @IBOutlet var inputFields: [UITextField]!
    var detailItem: [String:AnyObject] = [:]
    var delegate: AboutMeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        configView()
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
    
    func  configView(){
        let splitViewController = self.tabBarController!.viewControllers![0] as! UISplitViewController
        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let controller = masterNavigationController.topViewController as! MasterViewController
        
        let pref: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = pref.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn == 1 ){
            let useremail = pref.stringForKey("USERNAME")
            //print(useremail)
            
            let userInfo = controller.getUserInfo(useremail!)
            
            inputFields[0].text = userInfo.firstname
            inputFields[1].text = userInfo.lastname
            inputFields[2].text = userInfo.email
            inputFields[3].text = userInfo.phone
        }else{
            inputFields[0].text = ""
            inputFields[1].text = ""
            inputFields[2].text = ""
            inputFields[3].text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutView(sender: AnyObject) {
        let appdomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appdomain!)
        
        self.performSegueWithIdentifier("HomeView", sender: sender)
    }
    
    
}
