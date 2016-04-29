//
//  ResourcesTableViewController.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/28/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit

class ResourcesTableViewController: UITableViewController {
    
    var resources = [Resource]()
    var store: ResourceStore!
    let resourceTableDataSource = ResourceTableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton: UIBarButtonItem = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        rightButton.setTitleTextAttributes(attributes, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Filter)
        rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.tableView.dataSource = resourceTableDataSource
        store.fetchAllResources() {
            (resourcesResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock(){
            
                switch resourcesResult {
                case let .Success(resources):
                    print("Successfully found \(resources.count) resources.")
                    self.resourceTableDataSource.resources = resources
                case let .Failure(error):
                    self.resourceTableDataSource.resources.removeAll()
                    print("Error fetching resources: \(error)")
                }
                self.tableView.reloadData()
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        self.tableView.backgroundView?.backgroundColor = UIColor.darkGrayColor()
        self.tableView.sizeToFit()
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableViewAutomaticDimension
        default: ()
        return 150
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        default: ()
        return 150
        }
    }
   
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let imageCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ResourceImageViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
    }
}