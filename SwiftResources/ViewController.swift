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
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.color = UIColor.white
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubview(toFront: self.view)
        indicator.startAnimating()
        createUIElements()
        // Do any additional setup after loading the view, typically from a nib.
        if resourceItems.count == 0 {
            loadFirebaseCategories()
        }
        
        tableView.backgroundColor = UIColor.darkGray
        tableView.backgroundView?.backgroundColor = UIColor.darkGray
        tableView.isScrollEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createUIElements()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let conditionRef = rootRef.child("resources").queryOrderedByChild("parent_category").queryEqualToValue("Libraries and Frameworks")
    }
    
    func loadFirebaseCategories() {
        let conditionRef = rootRef.child("parent_category")
        conditionRef.observeSingleEvent(of: .value, with: { snap in
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CategoryTableViewCell
        cell.categoryLabel.text = resourceItems[indexPath.row].value as? String
        cell.categoryLabel.textColor = UIColor.white
        cell.categoryLabel.font = UIFont(name: (cell.categoryLabel?.font?.fontName)!, size: 24)
        cell.backgroundImage.image = UIImage(named: (resourceItems[indexPath.row].value as? String)!)
        cell.backgroundImage.layer.zPosition = -5;
        
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cellHeight))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        cell.backgroundImage.addSubview(overlay)

        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if segue.identifier == "categoryResources" {
            let destinationViewController = segue.destination as! CategoryResourceViewController
            let cell = sender as! CategoryTableViewCell
            destinationViewController.chosenCategory = cell.categoryLabel.text
        }
    }

}

