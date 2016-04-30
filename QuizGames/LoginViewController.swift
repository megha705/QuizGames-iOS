//
//  LoginViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/30/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
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
                        let connectionMsg = NSLocalizedString("invalidCredentials", comment: "")
                        let alert =  UIAlertController(title: nil, message: connectionMsg, preferredStyle: .Alert)
                        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
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
                    let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                    }
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
        }
        
        
    }
    
    
    @IBAction func onRegisterTap(sender: AnyObject) {
    }
}
