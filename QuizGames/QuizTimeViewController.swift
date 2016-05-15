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

class QuizTimeViewController: UIViewController {
    
    @IBOutlet weak var timeLimit: UIButton!
    @IBOutlet weak var noLimit: UIButton!
    var timedQuiz = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLimit.layer.cornerRadius = 5
        timeLimit.layer.borderWidth = 1
        timeLimit.layer.borderColor = UIColor.whiteColor().CGColor
        
        noLimit.layer.cornerRadius = 5
        noLimit.layer.borderWidth = 1
        noLimit.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let identifier = segue.identifier
        let destVc = (segue.destinationViewController as! QuizGamesSelectionViewController)
        if identifier == "showQuizes" {
            destVc.timedQuiz = timedQuiz
        }
    }
    
    @IBAction func onTimeLimitTap(sender: AnyObject) {
        timedQuiz = 1
        self.performSegueWithIdentifier("showQuizes", sender: sender)
    }
    
    @IBAction func onNoLimitTap(sender: AnyObject) {
        timedQuiz = 0
        self.performSegueWithIdentifier("showQuizes", sender: sender)
    }
    
    
}
