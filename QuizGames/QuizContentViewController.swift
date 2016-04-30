//
//  QuizPageViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/23/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit
import Kingfisher

class QuizContentViewController: UIViewController {
    var pageIndex: Int = 0
    var quizChoices: [QuizChoice]?
    var quizImg: String?
    @IBOutlet weak var selection1: UIButton!
    @IBOutlet weak var selection2: UIButton!
    @IBOutlet weak var selection3: UIButton!
    @IBOutlet weak var selection4: UIButton!
    @IBOutlet weak var questionImg: UIImageView!
    @IBOutlet weak var answer: UITextField!
    @IBOutlet weak var singleAnswer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var buttons = [selection1, selection2, selection3, selection4]
        quizChoices = quizChoices?.shuffle()
        questionImg.kf_setImageWithURL(NSURL(string: quizImg!)!)
        
        if (quizChoices?.count == 4) {
            for i in 0 ..< buttons.count {
                buttons[i].setTitle(quizChoices![i].choice, forState: .Normal)
                buttons[i].tag = quizChoices![i].isRightChoice!
                buttons[i].layer.cornerRadius = 5
                buttons[i].layer.borderWidth = 1
                buttons[i].layer.borderColor = UIColor.clearColor().CGColor
            }
        } else {
            selection1.hidden = true
            selection2.hidden = true
            selection3.hidden = true
            selection4.hidden = true
            answer.hidden = false
            singleAnswer.hidden = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSelectionButtonTap(sender: AnyObject) {
        if let quizPageVC = parentViewController?.parentViewController as? QuizPageViewController {
            quizPageVC.onSelectionButtonTap(sender.tag)
        }
    }
    
    @IBAction func onSingleAnswerTap(sender: AnyObject) {
        if let quizPageVC = parentViewController?.parentViewController as? QuizPageViewController {
            quizPageVC.onSingleAnswerClick(quizChoices![0].choice!, userInput: answer.text!)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
