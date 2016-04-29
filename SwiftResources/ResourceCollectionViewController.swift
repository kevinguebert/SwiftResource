//
//  ResourceCollectionViewController.swift
//  SwiftResources
//
//  Created by Kevin Guebert on 4/28/16.
//  Copyright © 2016 Kevin Guebert. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ResourceCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var resourcesArray = [["Pop", "https://github.com/facebook/pop", "An extensible iOS and OS X animation library, useful for physics-based interactions."],["AnimationEngine", "https://github.com/intuit/AnimationEngine", "Easily build advanced custom animations on iOS."],["Awesome-iOS-Animation", "https://github.com/jackyzh/awesome-ios-animation", "Collection of Animation projects"],["RZTransitions", "https://github.com/Raizlabs/RZTransitions", "A library of custom iOS View Controller Animations and Interactions."],["DCAnimationKit", "https://github.com/daltoniam/DCAnimationKit", "A collection of animations for iOS. Simple, just add water animations."],["Spring", "https://github.com/MengTo/Spring", "A library to simplify iOS animations in Swift."],["Canvas", "https://github.com/CanvasPod/Canvas", "Animate in Xcode without code http://canvaspod.io"],["Fluent", "https://github.com/matthewcheok/Fluent", "Swift animation made easy :large_orange_diamond:"],["Cheetah", "https://github.com/suguru/Cheetah", "Easy animation library on iOS with Swift2. :large_orange_diamond:"],["RadialLayer", "https://github.com/soheil/RadialLayer", "Animation for clickable elements (similar to Youtube Music). :large_orange_diamond:"],["Pop By Example", "https://github.com/hossamghareeb/Facebook-POP-Tutorial", "A project tutorial in how to use Pop animation framework by example."],["AppAnimations", "http://www.appanimations.com", "Collection of iOS animations to inspire your next project"],["EasyAnimation", "https://github.com/icanzilb/EasyAnimation", "A Swift library to take the power of UIView.animateWithDuration() to a whole new level - layers, springs, chain-able animations, and mixing view/layer animations together. :large_orange_diamond:"],["Animo", "https://github.com/eure/Animo", "SpriteKit-like animation builders for CALayers. :large_orange_diamond:"],["CurryFire", "https://github.com/devinross/curry-fire", "A framework for creating unique animations."],["IBAnimatable", "https://github.com/JakeLin/IBAnimatable", "Design and prototype UI, interaction, navigation, transition and animation for App Store ready Apps in Interface Builder with IBAnimatable. :large_orange_diamond:"],["CKWaveCollectionViewTransition", "https://github.com/CezaryKopacz/CKWaveCollectionViewTransition", "Cool wave like transition between two or more UICollectionView :large_orange_diamond:"],["DaisyChain", "https://github.com/alikaragoz/DaisyChain", ":link: Easy animation chaining :large_orange_diamond:"],["SYBlinkAnimationKit", "https://github.com/shoheiyokoyama/SYBlinkAnimationKit", "A blink effect animation framework for iOS, written in Swift. :large_orange_diamond:"],["PulsingHalo", "https://github.com/shu223/PulsingHalo", "iOS Component for creating a pulsing animation."],["DKChainableAnimationKit", "https://github.com/Draveness/DKChainableAnimationKit", ":star: Chainable animations in Swift :large_orange_diamond:[e]"],["JDAnimationKit", "https://github.com/JellyDevelopment/JDAnimationKit", "Animate easy and with less code with Swift :large_orange_diamond:"],["Advance", "https://github.com/storehouse/Advance", "A powerful animation framework for iOS. :large_orange_diamond:"],["UIView-Shake", "https://github.com/andreamazz/UIView-Shake", "UIView category that adds shake animation"],["Walker", "https://github.com/RamonGilabert/Walker", "A new animation engine for your app. :large_orange_diamond:"],["Morgan", "https://github.com/RamonGilabert/Morgan", "An animation set for your app. :large_orange_diamond:"],["MagicMove", "https://github.com/patrickreynolds/MagicMove", "Keynote-style Magic Move transition animations :large_orange_diamond:"],["Shimmer", "https://github.com/facebook/Shimmer", "An easy way to add a simple, shimmering effect to any view in an iOS app."],["SAConfettiView", "https://github.com/osteslag/Changeset", "Confetti! Who doesn't like confetti? :large_orange_diamond:"],["CCMRadarView", "https://github.com/cacmartinez/CCMRadarView", "CCMRadarView uses the IBDesignable tools to make an easy customizable radar view with animation :large_orange_diamond:"],["Pulsator", "https://github.com/shu223/Pulsator", "Pulse animation for iOS :large_orange_diamond:"]]
    
    var resources = [Resource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton: UIBarButtonItem = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        rightButton.setTitleTextAttributes(attributes, forState: .Normal)
        rightButton.title = String.fontAwesomeIconWithName(.Filter)
        rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "LibrariesFrameworks")!)
       
//        for a in resourcesArray {
//            let resource = Resource()
//                resource.title = a[0]
//                resource.url = NSURL(string: a[1])
//                resource.summary = a[2]
//            resources.append(resource)
//        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(resources.count)
        return resources.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / 3.0
        let size = CGSizeMake(UIScreen.mainScreen().bounds.size.width-10, cellWidth)
        return size
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "resourceBasicCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
//        let title = resources[indexPath.row].title
//        cell.title?.text = title
        
        return cell
    }
}