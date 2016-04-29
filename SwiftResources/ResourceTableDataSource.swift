//
//  ResourceTableDataSource.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/29/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit

class ResourceTableDataSource: NSObject, UITableViewDataSource {
    var resources = [Resource]()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return resources.count
        case 2:
            return 1
        default: ()
            return 1
        }
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
            cellIdentifier = "allResultsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            return cell
        }
    }
}