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
    var nicknameDialog = UIAlertController()
    
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
        
        // Create nickname  dialog
        let enterNickname = NSLocalizedString("enterNickname", comment: "")
        nicknameDialog = UIAlertController(title: enterNickname, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        var nicknameTextField = UITextField()
        
        let actionOkay = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Alamofire.request(.POST, "\(Util.quizGamesAPI)/results/\(self.quizType!)", parameters: ["name": nicknameTextField.text!, "score": self.score!], headers: nil, encoding: .JSON)
                .responseJSON { response in
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                    
                    if let _ = response.result.value {
                        // success
                        self.performSegueWithIdentifier("showMainView", sender: nil)
                    } else {
                        // show error
                    }
            }
        })
        nicknameDialog.addAction(actionOkay)
        // disable the ok button
        (nicknameDialog.actions[0] as UIAlertAction).enabled = false
        
        let cancel = NSLocalizedString("cancel", comment: "")
        let actionCancel = UIAlertAction(title: cancel, style: .Cancel, handler: {action in
            
        })
        nicknameDialog.addAction(actionCancel)
        // add textField
        nicknameDialog.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.addTarget(self, action: #selector(ScoreViewController.textChanged(_:)), forControlEvents: .EditingChanged)
            nicknameTextField = textField
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    @IBAction func onCancelBtnTap(sender: AnyObject) {
        performSegueWithIdentifier("showMainView", sender: sender)
    }
    @IBAction func onSubmitBtnTap(sender: AnyObject) {
        // show the nickname dialog
        presentViewController(nicknameDialog, animated: true, completion: nil)
    }
    
    // Fired when text changes in the description textField
    func textChanged(sender:AnyObject) {
        let tf = sender as! UITextField
        var resp : UIResponder = tf
        
        while !(resp is UIAlertController) {
            resp = resp.nextResponder()!
        }
        
        let alert = resp as! UIAlertController
        
        let tempString = tf.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        (alert.actions[0] as UIAlertAction).enabled = (tempString != "")
    }
    
}
