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

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submit.layer.cornerRadius = 5
        submit.layer.borderWidth = 1
        submit.layer.borderColor = UIColor.whiteColor().CGColor
        
        username.delegate = self
        username.tag = 1
        password.delegate = self
        password.tag = 2
        passwordConfirm.delegate = self
        passwordConfirm.tag = 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSubmitTap(sender: AnyObject) {
        let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default) { action -> Void in
        }
        let tempNickname = username.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let tempPassword = password.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        if tempNickname  == "" {
            let nicknameEmpty = NSLocalizedString("nicknameEmpty", comment: "")
            let alert =  UIAlertController(title: nil, message: nicknameEmpty, preferredStyle: .Alert)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if tempPassword == "" {
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
            submit.enabled = false
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
                    self.submit.enabled = true
                    
            }
            
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.resignFirstResponder()
            password.becomeFirstResponder()
        } else if textField.tag == 2 {
            textField.resignFirstResponder()
            passwordConfirm.becomeFirstResponder()
        } else if textField.tag == 3 {
            onSubmitTap(textField)
        }
        return true
    }
    
}
