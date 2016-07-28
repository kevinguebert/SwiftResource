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
import AZDropdownMenu

class CategoryResourceViewController: UITableViewController {
    
    var chosenCategory: String!
    
    var resourceItems = [FIRDataSnapshot]()
    var rootRef = FIRDatabase.database().reference()
    
    let filterActions = ["One", "Two", "Three"]
    var subCategories = [String]()
    var menu: AZDropdownMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = AZDropdownMenu(titles: filterActions)
        createUIElements()
        menu!.cellTapHandler = { [weak self] (indexPath: NSIndexPath) -> Void in
            self!.hideNavigationBar()
            self!.getFilteredResources()
        }
    }
    
    func getFilteredResources() {
        let conditionRef = rootRef.child("resources").queryOrderedByChild("sub_category")
        conditionRef.observeEventType(.Value, withBlock: { snap in
            for rest in snap.children.allObjects as! [FIRDataSnapshot] {
                print(rest)
            }
        })
        
    }
    func hideNavigationBar() {
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    func createUIElements() {
        let rightButton: UIBarButtonItem = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        rightButton.setTitleTextAttributes(attributes, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Filter)
        rightButton.action = #selector(CategoryResourceViewController.showDropdown)
        rightButton.target = self
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    func showDropdown() {
        if (self.menu?.isDescendantOfView(self.view) == true) {
            hideNavigationBar()
            self.menu?.hideMenu()
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.translucent = false
            self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
            self.menu?.showMenuFromView(self.view)
        }
    }
    
    
    func showModal() {
        let modalViewController = ModalViewController()
        modalViewController.modalPresentationStyle = .OverCurrentContext
        modalViewController.modalText?.text = "WOAH"
        modalViewController.modalContainer?.backgroundColor = UIColor.redColor()
        presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("The chosen category is \(chosenCategory)")
        if resourceItems.count == 0 {
            let conditionRef = rootRef.child("resources").queryOrderedByChild("parent_category").queryEqualToValue(chosenCategory)
            conditionRef.observeEventType(.Value, withBlock: { snap in
                for rest in snap.children.allObjects as! [FIRDataSnapshot] {
                    self.resourceItems.append(rest)
//                    self.subCategories.append(rest.sub_category)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        showModal()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        switch indexPath.section {
            case 0:
                cellIdentifier = "resourceImageCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResourceImageViewCell
                cell.categoryLabel.text = chosenCategory
                cell.categoryImage.layer.zPosition = -5;
                return cell
            case 1:
                cellIdentifier = "resourceCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResourcesTableViewCell
                let data = resourceItems[indexPath.row].value
                cell.resourcesTitle?.text = data?.valueForKey("name") as? String
                cell.resourcesSummary?.text = data?.valueForKey("summary") as? String
//                cell.resourcesSummary.sizeToFit()
                return cell
            default: ()
                cellIdentifier = "allResultsCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
                return cell
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let imageCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ResourceImageViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
        if scrollView.contentOffset.y >= 0 {
            self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        }
    }
}
