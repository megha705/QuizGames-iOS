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

class MainViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var topScoresButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playButton.layer.cornerRadius = 5
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        topScoresButton.layer.cornerRadius = 5
        topScoresButton.layer.borderWidth = 1
        topScoresButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        aboutButton.layer.cornerRadius = 5
        aboutButton.layer.borderWidth = 1
        aboutButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        if Util.userRoleId != 1 {
            addButton.enabled = false
            addButton.tintColor = UIColor.clearColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogoutTap(sender: AnyObject) {
        let logoutAsk = NSLocalizedString("logoutAsk", comment: "")
        let alert =  UIAlertController(title: nil, message: logoutAsk, preferredStyle: .Alert)
        let yesAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .Default) { action -> Void in
            let preferences = NSUserDefaults.standardUserDefaults()
            preferences.setInteger(0, forKey: Util.USER_ID_PREF)
            preferences.setInteger(0, forKey: Util.USER_ROLE_ID)
            self.performSegueWithIdentifier("showLoginView", sender: sender)
        }
        alert.addAction(yesAction)
        let noAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .Default) { action -> Void in
            
        }
        alert.addAction(noAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

