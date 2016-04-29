//
//  Resource.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/29/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit

class Resource {
    let title: String
    let url: NSURL
    let summary: String
    let category: String
    let is_swift: Int
    let dateAdded: NSDate
    let resourceID: String
    
    init(title: String, resourceID: String, url: NSURL, dateAdded: NSDate, summary: String, category: String, is_swift: Int) {
        self.title = title
        self.resourceID = resourceID
        self.url = url
        self.dateAdded = dateAdded
        self.summary = summary
        self.category = category
        self.is_swift = is_swift
    }
}
