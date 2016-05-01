//
//  RegisterViewController.swift
//  QuizGames
//
//  Created by Radoslav on 5/1/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submit.layer.cornerRadius = 5
        submit.layer.borderWidth = 1
        submit.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSubmitTap(sender: AnyObject) {
        let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default) { action -> Void in
        }
        let tempString = username.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        if tempString  == "" {
            let nicknameEmpty = NSLocalizedString("nicknameEmpty", comment: "")
            let alert =  UIAlertController(title: nil, message: nicknameEmpty, preferredStyle: .Alert)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if password.text == "" {
            let passwordEmpty = NSLocalizedString("passwordEmpty", comment: "")
            let alert =  UIAlertController(title: nil, message: passwordEmpty, preferredStyle: .Alert)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if password.text != passwordConfirm.text {
            let passwordDifferent = NSLocalizedString("passwordDifferent", comment: "")
            let alert =  UIAlertController(title: nil, message: passwordDifferent, preferredStyle: .Alert)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let params = [
                "username": username.text!,
                "password": password.text!
            ]
            Alamofire.request(.POST, "\(Util.quizGamesAPI)/register", parameters: params, headers: nil, encoding: .JSON)
                .responseJSON { response in
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    
                    if let results = response.result.value {
                        // print("JSON: \(results)")
                        if results["status"] as! String == "failure" {
                            // usernameExists
                            let usernameExists = NSLocalizedString("usernameExists", comment: "")
                            let alert =  UIAlertController(title: nil, message: usernameExists, preferredStyle: .Alert)
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        } else {
                            self.performSegueWithIdentifier("showLoginView", sender: sender)
                        }
                        
                    } else {
                        // failed to connect
                        let connectionMsg = NSLocalizedString("connectionMsg", comment: "")
                        let alert =  UIAlertController(title: nil, message: connectionMsg, preferredStyle: .Alert)
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
            }
            
            
        }
        
    }
    
    
}
