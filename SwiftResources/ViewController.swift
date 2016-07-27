//
//  ViewController.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 7/27/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit
import Firebase

class LaunchViewController: UITableViewController {

    var resourceItems = [FIRDataSnapshot]()
    
    var rootRef = FIRDatabase.database().reference()
    var chosenCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if resourceItems.count == 0 {
            loadFirebaseCategories()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        let conditionRef = rootRef.child("resources").queryOrderedByChild("parent_category").queryEqualToValue("Libraries and Frameworks")
    }
    
    func loadFirebaseCategories() {
        let conditionRef = rootRef.child("parent_category")
        conditionRef.observeSingleEventOfType(.Value, withBlock: { snap in
            for rest in snap.children.allObjects as! [FIRDataSnapshot] {
                self.resourceItems.append(rest)
            }
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        cell.textLabel!.text = resourceItems[indexPath.row].value as? String
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "categoryResources" {
            let destinationViewController = segue.destinationViewController as! CategoryResourceViewController
            let cell = sender as! UITableViewCell
            destinationViewController.chosenCategory = cell.textLabel?.text
        }
    }

}

