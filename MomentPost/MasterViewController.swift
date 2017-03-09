//
//  MasterViewController.swift
//  MomentPost
//
//  Created by Chenggang Xu on 7/4/16.
//  Copyright © 2016 Chenggang Xu. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, DetailViewControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    @IBOutlet weak var signin: UIBarButtonItem!
    @IBOutlet weak var signup: UIBarButtonItem!
    @IBOutlet weak var hometitle: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        //insertNewMoment()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        let pref: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let useremail = pref.stringForKey("USERNAME")
        let isLoggedIn:Int = pref.integerForKey("ISLOGGEDIN") as Int
        
        if (isLoggedIn == 1 ){
            print(true)
            let user = getUserInfo(useremail!)
            //let username = user.lastname! + "," + user.firstname!
            self.signup.title = ""
            self.signin.title = user.firstname
            self.signin.enabled = false
            //self.hometitle.title = username
        }else{
            print(false)
            self.signup.title = "Sign Up"
            self.signin.title = "Sign In"
            self.signin.enabled = true
            //self.hometitle.title = "Moment"
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewUser() {
        print("I am here")
        let context = self.userFetchedResultsController.managedObjectContext
        let entity = self.userFetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
             
        newManagedObject.setValue("James", forKey: "lastname")
        newManagedObject.setValue("Tom", forKey: "firstname")
        newManagedObject.setValue("a@a.com", forKey: "email")
        newManagedObject.setValue("123", forKey: "password")
        newManagedObject.setValue("4698888888", forKey: "phone")
             
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
    }
    
    func didSaveMoment(momentContent: String){
        
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/M/yyyy, H:mm"
        let dateString = dateFormatter.stringFromDate(date)
        
        let pref: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let useremail = pref.stringForKey("USERNAME")
        
        newManagedObject.setValue(dateString, forKey: "posttime")
        newManagedObject.setValue(useremail, forKey: "email")
        newManagedObject.setValue(momentContent, forKey: "moment")
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }

    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
            let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.delegate = self
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MomentTableViewCell
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        self.configureCell(cell, withObject: object)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //print("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }

    func configureCell(cell: MomentTableViewCell, withObject object: NSManagedObject) {
        let user = getUserInfo(object.valueForKey("email")!.description)
        cell.userName.text = user.lastname! + "," + user.firstname!
        //cell.userName.text = object.valueForKey("email")!.description
        cell.postTime.text = object.valueForKey("posttime")!.description
        cell.content.text = object.valueForKey("moment")!.description
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Moment", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "posttime", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             //print("Unresolved error \(error), \(error.userInfo)")
             abort()
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    var userFetchedResultsController: NSFetchedResultsController {
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = del.managedObjectContext
        
        if _userFetchedResultsController != nil {
            return _userFetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("UserInfo", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "lastname", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _userFetchedResultsController = aFetchedResultsController
        
        do {
            try _userFetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _userFetchedResultsController!
    }
    var _userFetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)! as! MomentTableViewCell, withObject: anObject as! NSManagedObject)
            case .Move:
                tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        //print("home")
    }
    
    func getUserInfo(content: String)->UserInfo{
        let fetchRequest = NSFetchRequest(entityName: "UserInfo")
        let context = self.userFetchedResultsController.managedObjectContext
        fetchRequest.predicate = NSPredicate(format: "email = %@", content)
        var managedObject:UserInfo?
        //SecondfetchRequest.predicate = NSPredicate(format: "id = %d", 50055005)
        
        if let results = try? context.executeFetchRequest(fetchRequest) as! [UserInfo] {
            //results.count
            //results[0].fullname
            if results.count > 0 {
                managedObject = results[0]
            }
            //coreDataStack.context.deleteObject(managedObject) // DELete  data
        } else {
            print("There was an error getting the results")
        }
        return managedObject!
    }
    
    func checkUserInfo(content: String)->Bool{
        let fetchRequest = NSFetchRequest(entityName: "UserInfo")
        let context = self.userFetchedResultsController.managedObjectContext
        fetchRequest.predicate = NSPredicate(format: "email = %@", content)
        //SecondfetchRequest.predicate = NSPredicate(format: "id = %d", 50055005)
        
        if let results = try? context.executeFetchRequest(fetchRequest) as! [UserInfo] {
            if results.count > 0 {
                return true
            }
        } else {
            print("There was an error getting the results")
        }
        return false
    }
    
    func didSaveUser(content: [String]) {
        let context = self.userFetchedResultsController.managedObjectContext
        let entity = self.userFetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
        
        newManagedObject.setValue(content[0], forKey: "email")
        newManagedObject.setValue(content[1], forKey: "password")
        newManagedObject.setValue(content[2], forKey: "phone")
        newManagedObject.setValue(content[3], forKey: "firstname")
        newManagedObject.setValue(content[4], forKey: "lastname")
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }

    }
    
    func didLogIn(content: [String]) -> Bool{
        
        let fetchRequest = NSFetchRequest(entityName: "UserInfo")
        let context = self.userFetchedResultsController.managedObjectContext
        fetchRequest.predicate = NSPredicate(format: "email = %@ and password = %@", content[0], content[1])
        
        if let results = try? context.executeFetchRequest(fetchRequest) as! [UserInfo] {
            //results.count
            //results[0].fullname
            if results.count > 0 {
                return true
            }
            //coreDataStack.context.deleteObject(managedObject) // DELete  data
        } else {
            print("There was an error getting the results")
        }
        
        return false
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

