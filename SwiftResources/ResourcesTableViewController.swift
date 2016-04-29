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
//    let resourceDataSource = ResourceDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton: UIBarButtonItem = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        rightButton.setTitleTextAttributes(attributes, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Filter)
        rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightButton
        
        store.fetchAllResources() {
            (resourcesResult) -> Void in
            
            switch resourcesResult {
            case let .Success(resources):
                print("Successfully found \(resources.count) resources.")
            case let .Failure(error):
                print("Error fetching resources: \(error)")
            }
        }
        
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        self.tableView.backgroundView?.backgroundColor = UIColor.darkGrayColor()
        self.tableView.sizeToFit()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default: ()
        return resources.count
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
            cellIdentifier = "resourceTableCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResourcesTableViewCell
            cell.resourcesTitle?.text = resources[indexPath.row].title
            cell.resourcesSummary?.text = resources[indexPath.row].summary
            return cell
        default: ()
            cellIdentifier = "resourceTableCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResourcesTableViewCell
            return cell
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let imageCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ResourceImageViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
    }
}