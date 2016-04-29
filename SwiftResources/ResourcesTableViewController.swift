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
    
    @IBOutlet var searchViewDropdown: UIView!
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height: CGFloat = self.searchViewDropdown.frame.size.height
        let width: CGFloat = self.searchViewDropdown.frame.size.width
        self.searchViewDropdown.frame = CGRectMake(0, -height, width, height)
        self.dropDownViewIsDisplayed = false
        self.searchViewDropdown.hidden = true
        
        let rightButton: UIBarButtonItem = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        rightButton.setTitleTextAttributes(attributes, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Filter)
        rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(ResourcesTableViewController.filterDropdown)
        
        self.tableView.dataSource = resourceTableDataSource
        self.tableView.delegate = self
        store.fetchAllResources() {
            (resourcesResult) -> Void in
            
            let sortByDateAdded = NSSortDescriptor(key: "dateAdded", ascending: true)
            let allResources = try! self.store.fetchMainQueueResources(predicate: nil, sortDescriptors: [sortByDateAdded])
            NSOperationQueue.mainQueue().addOperationWithBlock(){
                self.resourceTableDataSource.resources = allResources
                self.tableView.reloadData()
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        self.tableView.backgroundView?.backgroundColor = UIColor.darkGrayColor()
        self.tableView.sizeToFit()
    }
    
    func filterDropdown() {
        if(self.dropDownViewIsDisplayed) {
            self.hideDropDownView()
        } else {
            self.showDropDownView()
        }
    }
    
    func hideDropDownView() {
        var frame  = self.searchViewDropdown.frame
//        frame.origin.y = 0
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        frame.origin.y = -frame.size.height
        self.animateDropDownToFrame(frame) {
            self.dropDownViewIsDisplayed = false
        }
        self.searchViewDropdown.hidden = true
    }
    
    func showDropDownView() {
        self.searchViewDropdown.hidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        var frame = self.searchViewDropdown.frame
        frame.origin.y = 0
        self.animateDropDownToFrame(frame) {
            self.dropDownViewIsDisplayed = true
        }
    }
    
    func animateDropDownToFrame(frame: CGRect, completion:() -> Void) {
        print(frame)
        if (!isAnimating) {
            isAnimating = true
            UIView.animateWithDuration(1.5, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.searchViewDropdown.frame = frame
                }, completion: { (completed: Bool) -> Void in
                    self.isAnimating = false
                    if (completed) {
                        completion()
                    }
            })
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
   
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let imageCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ResourceImageViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
    }
}