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
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberMe: UISwitch!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login.layer.cornerRadius = 5
        login.layer.borderWidth = 1
        login.layer.borderColor = UIColor.whiteColor().CGColor
        
        register.layer.cornerRadius = 5
        register.layer.borderWidth = 1
        register.layer.borderColor = UIColor.whiteColor().CGColor
        
        username.delegate = self
        username.tag = 1
        password.delegate = self
        password.tag = 2
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let preferences = NSUserDefaults.standardUserDefaults()
        let userId = preferences.integerForKey(Util.USER_ID_PREF)
        if userId != 0 {
            Util.userId = userId
            Util.userRoleId = preferences.integerForKey(Util.USER_ROLE_ID)
            self.performSegueWithIdentifier("showMainView", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLoginTap(sender: AnyObject) {
        let params = [
            "username": username.text!,
            "password": password.text!
        ]
        Alamofire.request(.POST, "\(Util.quizGamesAPI)/login", parameters: params, headers: nil, encoding: .JSON)
            .responseJSON { response in
                // print(response.request)  // original URL request
                // print(response.response) // URL response
                // print(response.data)     // server data
                // print(response.result)   // result of response serialization
                
                if let results = response.result.value {
                    // print("JSON: \(results)")
                    if results["status"] as! String == "failure" {
                        // invalid credentials
                        let invalidCredentials = NSLocalizedString("invalidCredentials", comment: "")
                        let alert =  UIAlertController(title: nil, message: invalidCredentials, preferredStyle: .Alert)
                        let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default) { action -> Void in
                        }
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        if self.rememberMe.on {
                            let preferences = NSUserDefaults.standardUserDefaults()
                            preferences.setInteger(results["id"] as! Int, forKey: Util.USER_ID_PREF)
                            preferences.setInteger(results["user_roleId"] as! Int, forKey: Util.USER_ROLE_ID)
                        }
                        Util.userId = results["id"] as! Int
                        Util.userRoleId = results["user_roleId"] as! Int
                        self.performSegueWithIdentifier("showMainView", sender: sender)
                    }
                    
                } else {
                    // failed to connect
                    let connectionMsg = NSLocalizedString("connectionMsg", comment: "")
                    let alert =  UIAlertController(title: nil, message: connectionMsg, preferredStyle: .Alert)
                    let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default) { action -> Void in
                    }
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.resignFirstResponder()
            password.becomeFirstResponder()
        } else if textField.tag == 2 {
            onLoginTap(textField)
        }
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}
