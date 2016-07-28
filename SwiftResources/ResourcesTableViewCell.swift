//
//  ResourcesTableViewCell.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 7/27/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit

class ResourcesTableViewCell: UITableViewCell {
    @IBOutlet var resourcesTitle: UILabel?
    @IBOutlet var resourcesSummary: UILabel!
    @IBOutlet var cardView: UIView!
    
    override func layoutSubviews() {
        self.cardView.layer.masksToBounds = true
        self.cardView.layer.cornerRadius = 1
//        resourcesSummary.adjustsFontSizeToFitWidth = true
//        resourcesSummary.sizeToFit()
    }
    
}