//
//  ResourceImageViewCell.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/28/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit

class ResourceImageViewCell: UITableViewCell {
    
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0 {
            // scrolling up
            containerView.clipsToBounds = true
            bottomSpaceConstraint?.constant = -scrollView.contentOffset.y / 2
            topSpaceConstraint?.constant = scrollView.contentOffset.y / 2
        } else {
            // scrolling down
            topSpaceConstraint?.constant = scrollView.contentOffset.y
            containerView.clipsToBounds = false
        }
    }
}