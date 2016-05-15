/*
 *  Copyright 2016 Radoslav Yordanov
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

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
