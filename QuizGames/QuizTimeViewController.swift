//
//  QuizTImeViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/30/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

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
