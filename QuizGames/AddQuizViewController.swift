//
//  AddQuizViewController.swift
//  QuizGames
//
//  Created by Radoslav on 5/1/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit
import Alamofire

class AddQuizViewController: UIViewController, UITextFieldDelegate {
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
    var contentMoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        add.layer.cornerRadius = 5
        add.layer.borderWidth = 1
        add.layer.borderColor = view.tintColor.CGColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddQuizViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddQuizViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        quizImg.delegate = self
        quizImg.tag = 1
        singleAnswer.delegate = self
        singleAnswer.tag = 2
        choice1.delegate = self
        choice1.tag = 3
        choice2.delegate = self
        choice2.tag = 4
        choice3.delegate = self
        choice3.tag = 5
        choice4.delegate = self
        choice4.tag = 6
        
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
    
    func keyboardWillShow(notification: NSNotification) {
        if multipleChoices.on && contentMoved == false {
            self.view.frame.origin.y -= 70
            contentMoved = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            if multipleChoices.on {
                choice1.becomeFirstResponder()
            } else {
                singleAnswer.becomeFirstResponder()
            }
        case 2:
            textField.resignFirstResponder()
            onAddTap(textField)
            if contentMoved == true {
                self.view.frame.origin.y += 70
                contentMoved = false
            }
        case 3:
            textField.resignFirstResponder()
            choice2.becomeFirstResponder()
        case 4:
            textField.resignFirstResponder()
            choice3.becomeFirstResponder()
        case 5:
            textField.resignFirstResponder()
            choice4.becomeFirstResponder()
        case 6:
            textField.resignFirstResponder()
            if contentMoved == true {
                self.view.frame.origin.y += 70
                contentMoved = false
            }
        default: break
        }
        
        return true
    }
}
