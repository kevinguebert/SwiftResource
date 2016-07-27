//
//  CategoryResourcesViewController.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 7/27/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CategoryResourceViewController: UITableViewController {
    
    var chosenCategory: String!
    
    var resourceItems = [FIRDataSnapshot]()
    var rootRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("The chosen category is \(chosenCategory)")
        if resourceItems.count == 0 {
            let conditionRef = rootRef.child("resources").queryOrderedByChild("parent_category").queryEqualToValue(chosenCategory)
            conditionRef.observeEventType(.Value, withBlock: { snap in
                for rest in snap.children.allObjects as! [FIRDataSnapshot] {
                    self.resourceItems.append(rest)
                }
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resourceCell")! as UITableViewCell
        let data = resourceItems[indexPath.row].value
        cell.textLabel!.text = data?.valueForKey("name") as? String
        return cell
    }
}
