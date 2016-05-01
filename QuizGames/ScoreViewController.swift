//
//  ScoreViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/25/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

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
    
    
    
}
