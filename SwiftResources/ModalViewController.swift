//
//  ModalViewController.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 7/28/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    @IBOutlet var modalContainer: UIView!
    @IBOutlet var modalText: UILabel!
    override func viewDidLoad() {
//        view.backgroundColor = UIColor.clearColor()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        modalContainer?.backgroundColor = UIColor.redColor()
        print("HERE")
//        view.opaque = false
    }
}