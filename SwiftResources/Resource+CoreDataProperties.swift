//
//  Resource+CoreDataProperties.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/29/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Resource {

    @NSManaged var title: String?
    @NSManaged var summary: String?
    @NSManaged var url: NSObject?
    @NSManaged var resourceID: String?
    @NSManaged var is_swift: NSNumber?
    @NSManaged var date_added: NSDate?

}
