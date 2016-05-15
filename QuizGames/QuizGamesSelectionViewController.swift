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

class QuizGamesSelectionViewController: UIViewController {
    
    @IBOutlet weak var carsQuizButton: UIButton!
    @IBOutlet weak var logosQuizButton: UIButton!
    @IBOutlet weak var citiesQuizButton: UIButton!
    var timedQuiz: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        carsQuizButton.layer.cornerRadius = 5
        carsQuizButton.layer.borderWidth = 1
        carsQuizButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        logosQuizButton.layer.cornerRadius = 5
        logosQuizButton.layer.borderWidth = 1
        logosQuizButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        citiesQuizButton.layer.cornerRadius = 5
        citiesQuizButton.layer.borderWidth = 1
        citiesQuizButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCarsQuizTap(sender: AnyObject) {
        performSegueWithIdentifier("cars", sender: sender)
    }
    
    @IBAction func onLogosQuizTap(sender: AnyObject) {
        performSegueWithIdentifier("logos", sender: sender)
    }
    
    @IBAction func onCitiesQuizTap(sender: AnyObject) {
        performSegueWithIdentifier("cities", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let identifier = segue.identifier
        let destVc = (segue.destinationViewController as! QuizPageViewController)
        destVc.quizType = identifier
        destVc.timedQuiz = timedQuiz
    }
    
}
