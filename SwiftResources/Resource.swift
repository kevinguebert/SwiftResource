//
//  Resource.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/29/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit
import CoreData

class Resource: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override func awakeFromInsert() {
        super.awakeFromInsert()
        title = ""
        resourceID = ""
        summary = ""
        category = ""
        dateAdded = NSDate()
        url = NSURL()
        is_swift = false
    }

}
