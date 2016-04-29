//
//  CategoryTableViewController.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/28/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CategoryTableViewController: UITableViewController {
    @IBOutlet var categoryTableView: UITableView!
    var store: ResourceStore!
//    let resourceDataSource = ResourceDataSource()
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //  Swift 1.2, which is why I'm using 'let' here.
        let height: CGFloat
        
        //  It is assumed there is only one section.
        if let normalisedHeight = self.normalisedCellHeights?[indexPath.row] {
            height = normalisedHeight * tableView.frame.height
        } else {
            height = 50.0 // Just a random value.
        }
        
        return height
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(30)] as Dictionary!
        navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes, forState: .Normal)
        navigationItem.backBarButtonItem?.title = String.fontAwesomeIconWithName(.AngleLeft)
        navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        navigationItem.setHidesBackButton(true, animated: false)
        if segue.identifier == "ShowResource" {
            let destinationVC = segue.destinationViewController as! ResourcesTableViewController
            destinationVC.store = store
        }
        
    }
}