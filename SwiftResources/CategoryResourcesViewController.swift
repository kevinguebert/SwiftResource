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
    var allResourceData = [FIRDataSnapshot]()
    var rootRef = FIRDatabase.database().reference()
    
    let filterActions = ["One", "Two", "Three"]
    var subCategories = ["All"]

    override func viewDidLoad() {
        super.viewDidLoad()
        createUIElements()
    }
    
    func filterData(_ predicate: String) {
        let filteredData = allResourceData.filter({
            let data = $0.value! as AnyObject
            if predicate == "All" {
                return true
            } else {
                return data["sub_category"] as! String == predicate
            }
        })
        resourceItems = filteredData
        tableView.reloadData()
        tableView.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.automatic)
        
    }
    
    func getFilteredResources() {
        let conditionRef = rootRef.child("resources").queryOrdered(byChild: "sub_category")
        conditionRef.observe(.value, with: { snap in
            for rest in snap.children.allObjects as! [FIRDataSnapshot] {
                print(rest)
            }
        })
        
    }
    func hideNavigationBar() {
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func createUIElements() {
        let rightButton: UIBarButtonItem = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as Dictionary!
        rightButton.setTitleTextAttributes(attributes, for: .normal)
        rightButton.title = String.fontAwesomeIcon(name: .filter)
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func showModal() {
        let modalViewController = ModalViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.modalText?.text = "WOAH"
        modalViewController.modalContainer?.backgroundColor = UIColor.red
        present(modalViewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("The chosen category is \(chosenCategory)")
        if resourceItems.count == 0 {
            let conditionRef = rootRef.child("resources").queryOrdered(byChild: "parent_category").queryEqual(toValue: chosenCategory)
            conditionRef.observe(.value, with: { snap in
                print(snap)
                for rest in snap.children.allObjects as! [FIRDataSnapshot] {
                    self.resourceItems.append(rest)
                    self.allResourceData.append(rest)
                    let data = rest.value
                    for _ in self.subCategories {
                        if !self.subCategories.contains((data as AnyObject).value(forKey: "sub_category") as! String) {
                            self.subCategories.append((data as AnyObject).value(forKey: "sub_category") as! String)
                        }
                    }
                }
                print(self.subCategories)
                self.tableView.reloadData()
                self.tableView.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.automatic)
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return UITableViewAutomaticDimension
            case 1:
                return 130
            default: ()
                return 45
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 200
            case 1:
                return 130
            default: ()
                return 45
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        showModal()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        switch indexPath.section {
            case 0:
                cellIdentifier = "resourceImageCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResourceImageViewCell
                cell.categoryLabel.text = chosenCategory
                cell.categoryImage.layer.zPosition = -5;
                cell.categoryImage.image = UIImage(named: chosenCategory)
                
                return cell
            case 1:
                cellIdentifier = "resourceCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResourcesTableViewCell
                let data = resourceItems[indexPath.row].value
                cell.resourcesTitle?.text = (data as AnyObject).value(forKey: "name") as? String
                cell.resourcesSummary?.text = (data as AnyObject).value(forKey: "summary") as? String
                return cell
            default: ()
                cellIdentifier = "allResultsCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                return cell
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ResourceImageViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
        if scrollView.contentOffset.y >= 0 {
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
    }
}
