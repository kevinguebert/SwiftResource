//
//  ViewController.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 7/27/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Firebase

class LaunchViewController: UITableViewController {

    var resourceItems = [FIRDataSnapshot]()
    
    var rootRef = FIRDatabase.database().reference()
    var chosenCategory = ""
    
    var cellHeight:CGFloat = 0
    var absoluteCellHeights: [CGFloat] = [25, 25, 25, 25] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var normalisedCellHeights: [CGFloat]? {
        let totalHeight = absoluteCellHeights.reduce(0) { $0 + $1 }
        let normalisedHeights: [CGFloat]? = totalHeight <= 0 ? nil : absoluteCellHeights.map { $0 / totalHeight }
        
        return normalisedHeights
    }
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.color = UIColor.whiteColor()
        indicator.frame = CGRectMake(0, 0, 40, 40)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        createUIElements()
        // Do any additional setup after loading the view, typically from a nib.
        if resourceItems.count == 0 {
            loadFirebaseCategories()
        }
        
        tableView.backgroundColor = UIColor.darkGrayColor()
        tableView.backgroundView?.backgroundColor = UIColor.darkGrayColor()
        tableView.scrollEnabled = false
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height: CGFloat
        
        if let normalisedHeight = self.normalisedCellHeights?[indexPath.row] {
            height = normalisedHeight * tableView.frame.height
        } else {
            height = 50.0 // Just a random value.
        }
        
        cellHeight = height
        return height
    }
    
    func createUIElements() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        createUIElements()
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
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
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
        let cell: CategoryTableViewCell  = tableView.dequeueReusableCellWithIdentifier("Cell") as! CategoryTableViewCell
        cell.categoryLabel.text = resourceItems[indexPath.row].value as? String
        cell.categoryLabel.textColor = UIColor.whiteColor()
        cell.categoryLabel.font = UIFont(name: (cell.categoryLabel?.font?.fontName)!, size: 24)
        cell.backgroundImage.image = UIImage(named: (resourceItems[indexPath.row].value as? String)!)
        cell.backgroundImage.layer.zPosition = -5;
        
        let overlay: UIView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cellHeight))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        cell.backgroundImage.addSubview(overlay)

        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        if segue.identifier == "categoryResources" {
            let destinationViewController = segue.destinationViewController as! CategoryResourceViewController
            let cell = sender as! CategoryTableViewCell
            destinationViewController.chosenCategory = cell.categoryLabel.text
        }
    }

}

