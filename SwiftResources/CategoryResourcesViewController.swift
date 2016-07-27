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
import FontAwesome_swift

class CategoryResourceViewController: UITableViewController {
    
    var chosenCategory: String!
    
    var resourceItems = [FIRDataSnapshot]()
    var rootRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Chosen category \(chosenCategory)")
        createUIElements()
    }
    
    func createUIElements() {
        let rightButton: UIBarButtonItem = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        rightButton.setTitleTextAttributes(attributes, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Filter)
        self.navigationItem.rightBarButtonItem = rightButton

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
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
                
            })
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return resourceItems.count
            case 2:
                return 1
            default: ()
                return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return UITableViewAutomaticDimension
            case 1:
                return 130
            default: ()
                return 45
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 200
            case 1:
                return 130
            default: ()
                return 45
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        switch indexPath.section {
            case 0:
                cellIdentifier = "resourceImageCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
                return cell
            case 1:
                cellIdentifier = "resourceCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResourcesTableViewCell
                let data = resourceItems[indexPath.row].value
                cell.resourcesTitle?.text = data?.valueForKey("name") as? String
                cell.resourcesSummary?.text = data?.valueForKey("summary") as? String
                return cell
            default: ()
                cellIdentifier = "allResultsCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
                return cell
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        print("Scroll view did scroll")
        if let imageCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ResourceImageViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
    }
}
