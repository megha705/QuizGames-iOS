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

class ScoreViewController: UIViewController {
    var score: Int?
    var quizType: String?
    var correctAnswers: Int?
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var ansQuestionsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderWidth = 1
        submitBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        let scoreResult = String(format: NSLocalizedString("scoreResult", comment: ""), String(score!))
        scoreLbl.text = scoreResult
        
        let answeredQuestions = String(format: NSLocalizedString("answeredQuestions", comment: ""), String(correctAnswers!))
        ansQuestionsLbl.text = answeredQuestions
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelBtnTap(sender: AnyObject) {
        performSegueWithIdentifier("showMainView", sender: sender)
    }
    
    @IBAction func onSubmitBtnTap(sender: AnyObject) {
        Alamofire.request(.POST, "\(Util.quizGamesAPI)/results/\(self.quizType!)", parameters: ["user_id": Util.userId, "score": self.score!], headers: nil, encoding: .JSON)
            .responseJSON { response in
                // print(response.request)  // original URL request
                // print(response.response) // URL response
                // print(response.data)     // server data
                // print(response.result)   // result of response serialization
                
                if let _ = response.result.value {
                    // success
                    self.performSegueWithIdentifier("showMainView", sender: nil)
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}
