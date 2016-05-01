//
//  AddQuizViewController.swift
//  QuizGames
//
//  Created by Radoslav on 5/1/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit
import Alamofire

class AddQuizViewController: UIViewController {
    @IBOutlet weak var quizType: UISegmentedControl!
    @IBOutlet weak var quizImg: UITextField!
    @IBOutlet weak var multipleChoices: UISwitch!
    @IBOutlet weak var singleAnswer: UITextField!
    @IBOutlet weak var choice1: UITextField!
    @IBOutlet weak var choice2: UITextField!
    @IBOutlet weak var choice3: UITextField!
    @IBOutlet weak var choice4: UITextField!
    @IBOutlet weak var correctChoice: UISegmentedControl!
    @IBOutlet weak var correctChoiceText: UILabel!
    @IBOutlet weak var singleAnswerContainer: UIStackView!
    @IBOutlet weak var multipleAnswerContainer: UIStackView!
    @IBOutlet weak var addButtonTopConstant: NSLayoutConstraint!
    @IBOutlet weak var add: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        add.layer.cornerRadius = 5
        add.layer.borderWidth = 1
        add.layer.borderColor = view.tintColor.CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onChangeQuestionTypeTap(sender: AnyObject) {
        if multipleChoices.on {
            singleAnswerContainer.hidden = true
            multipleAnswerContainer.hidden = false
            correctChoice.hidden = false
            correctChoiceText.hidden = false
            addButtonTopConstant.constant = 240
        } else {
            singleAnswerContainer.hidden = false
            multipleAnswerContainer.hidden = true
            correctChoice.hidden = true
            correctChoiceText.hidden = true
            addButtonTopConstant.constant = 80
        }
    }
    
    
    @IBAction func onAddTap(sender: AnyObject) {
        let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default) { action -> Void in
        }
        let tempQuizImg = quizImg.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        if tempQuizImg == "" {
            let quizImgEmpty = NSLocalizedString("quizImgEmpty", comment: "")
            let alert =  UIAlertController(title: nil, message: quizImgEmpty, preferredStyle: .Alert)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if !quizImg.text!.hasPrefix("http://") && !quizImg.text!.hasPrefix("https://") {
            let quizImgInvalid = NSLocalizedString("quizImgInvalid", comment: "")
            let alert =  UIAlertController(title: nil, message: quizImgInvalid, preferredStyle: .Alert)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if multipleChoices.on {
            let tempChoice1 = choice1.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
            let tempChoice2 = choice2.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
            let tempChoice3 = choice3.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
            let tempChoice4 = choice4.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
            if tempChoice1 == "" {
                let quizChoiceEmpty = NSLocalizedString("quizChoiceEmpty", comment: "")
                let alert =  UIAlertController(title: nil, message: quizChoiceEmpty, preferredStyle: .Alert)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            if tempChoice2 == "" {
                let quizChoiceEmpty = NSLocalizedString("quizChoiceEmpty", comment: "")
                let alert =  UIAlertController(title: nil, message: quizChoiceEmpty, preferredStyle: .Alert)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            if tempChoice3 == "" {
                let quizChoiceEmpty = NSLocalizedString("quizChoiceEmpty", comment: "")
                let alert =  UIAlertController(title: nil, message: quizChoiceEmpty, preferredStyle: .Alert)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            if tempChoice4 == "" {
                let quizChoiceEmpty = NSLocalizedString("quizChoiceEmpty", comment: "")
                let alert =  UIAlertController(title: nil, message: quizChoiceEmpty, preferredStyle: .Alert)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            let correctChoiceId = correctChoice.selectedSegmentIndex + 1
            let quizChoice1 = QuizChoice()
            quizChoice1.choice = choice1.text
            quizChoice1.isRightChoice = correctChoiceId == 1 ? 1 : 0
            
            let quizChoice2 = QuizChoice()
            quizChoice2.choice = choice2.text
            quizChoice2.isRightChoice = correctChoiceId == 2 ? 1 : 0
            
            let quizChoice3 = QuizChoice()
            quizChoice3.choice = choice3.text
            quizChoice3.isRightChoice = correctChoiceId == 3 ? 1 : 0
            
            let quizChoice4 = QuizChoice()
            quizChoice4.choice = choice4.text
            quizChoice4.isRightChoice = correctChoiceId == 4 ? 1 : 0
            
            let quiz = Quiz()
            quiz.quizImage = quizImg.text
            quiz.quizType = quizType.titleForSegmentAtIndex(quizType.selectedSegmentIndex)?.lowercaseString
            quiz.addQuizChoice(quizChoice1)
            quiz.addQuizChoice(quizChoice2)
            quiz.addQuizChoice(quizChoice3)
            quiz.addQuizChoice(quizChoice4)
            addQuiz(quiz)
        } else {
            let tempSingleAnswer = singleAnswer.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
            if tempSingleAnswer == "" {
                let quizAnswerEmpty = NSLocalizedString("quizAnswerEmpty", comment: "")
                let alert =  UIAlertController(title: nil, message: quizAnswerEmpty, preferredStyle: .Alert)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            let quiz = Quiz()
            quiz.quizImage = quizImg.text
            quiz.quizType = quizType.titleForSegmentAtIndex(quizType.selectedSegmentIndex)?.lowercaseString
            let quizChoice1 = QuizChoice()
            quizChoice1.choice = singleAnswer.text
            quizChoice1.isRightChoice = 1
            quiz.addQuizChoice(quizChoice1)
            addQuiz(quiz)
        }
        
    }
    
    func addQuiz(quiz: Quiz) {
        add.enabled = false
        Alamofire.request(.POST, "\(Util.quizGamesAPI)/addQuiz", parameters: quiz.toJSON() as? [String : AnyObject], headers: nil, encoding: .JSON)
            .responseJSON { response in
                // print(response.request)  // original URL request
                // print(response.response) // URL response
                // print(response.data)     // server data
                // print(response.result)   // result of response serialization
                
                if let results = response.result.value {
                    // print("JSON: \(results)")
                    if results["status"] as! String == "success" {
                        self.navigationController?.popViewControllerAnimated(true)
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
                self.add.enabled = true
        }
        
    }
}
