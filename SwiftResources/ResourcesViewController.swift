//
//  ResourcesViewController.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/29/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit

class ResourcesViewController: UIViewController, UITableViewDelegate {
    
    var resources = [Resource]()
    var store: ResourceStore!
    let resourceTableDataSource = ResourceTableDataSource()
    
    @IBOutlet var resourcesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton: UIBarButtonItem = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        rightButton.setTitleTextAttributes(attributes, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Filter)
        rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightButton
        
        resourcesTableView.dataSource = resourceTableDataSource
        resourcesTableView.delegate = self
        store.fetchAllResources() {
            (resourcesResult) -> Void in
            
            let sortByDateAdded = NSSortDescriptor(key: "dateAdded", ascending: true)
            let allResources = try! self.store.fetchMainQueueResources(predicate: nil, sortDescriptors: [sortByDateAdded])
            NSOperationQueue.mainQueue().addOperationWithBlock(){
                self.resourceTableDataSource.resources = allResources
                self.resourcesTableView.reloadData()
                self.resourcesTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
        resourcesTableView.backgroundColor = UIColor.darkGrayColor()
        resourcesTableView.backgroundView?.backgroundColor = UIColor.darkGrayColor()
        resourcesTableView.sizeToFit()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            return 130
        default: ()
        return 45
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 1:
            return 130
        default: ()
        return 45
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let imageCell = resourcesTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ResourceImageViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
    }
}