//
//  TopScoresViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/26/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit

class TopScoresViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var currentViewController: UIViewController?
    var carsVC : UIViewController?
    var logosVC : UIViewController?
    var citiesVC : UIViewController?
    var allVC : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayCurrentTab(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayCurrentTab(tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMoveToParentViewController(self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case 0 :
            if carsVC == nil {
                carsVC = self.storyboard?.instantiateViewControllerWithIdentifier("topScoresChildView") as!TopScoresChildViewController
                (carsVC as? TopScoresChildViewController)!.resultsType = "cars"
            }
            vc = carsVC
        case 1 :
            if logosVC == nil {
                logosVC = self.storyboard?.instantiateViewControllerWithIdentifier("topScoresChildView") as!TopScoresChildViewController
                (logosVC as? TopScoresChildViewController)!.resultsType = "logos"
            }
            vc = logosVC
        case 2 :
            if citiesVC == nil {
                citiesVC = self.storyboard?.instantiateViewControllerWithIdentifier("topScoresChildView") as!TopScoresChildViewController
                (citiesVC as? TopScoresChildViewController)!.resultsType = "cities"
            }
            vc = citiesVC
        case 3 :
            if allVC == nil {
                allVC = self.storyboard?.instantiateViewControllerWithIdentifier("topScoresChildView") as!TopScoresChildViewController
                (allVC as? TopScoresChildViewController)!.resultsType = "all"
            }
            vc = allVC
        default:
            return nil
        }
        return vc
    }
    
    @IBAction func switchTabs(sender: AnyObject) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
}
