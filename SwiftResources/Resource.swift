//
//  Resource.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 7/27/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import Foundation

struct Resource {
    let key: Int!
    let name: String!
    let url: String!
    let summary: String!
    let parent_category: String!
    let sub_category: String!
    
    
    init(name: String, url: String, summary: String, parent_category: String, sub_category: String, key: Int) {
        self.name = name
        self.url = url
        self.summary = summary
        self.parent_category = parent_category
        self.sub_category = sub_category
        self.key = key
    }
}