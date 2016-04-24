//
//  QuizPageViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/23/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    var pageIndex: Int = 0
    var quizChoices: [QuizChoice]?
    var quizImg: String?
    @IBOutlet weak var selection1: UIButton!
    @IBOutlet weak var selection2: UIButton!
    @IBOutlet weak var selection3: UIButton!
    @IBOutlet weak var selection4: UIButton!
    @IBOutlet weak var questionImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var buttons = [selection1, selection2, selection3, selection4]
        quizChoices?.shuffle()
        for i in 0 ..< buttons.count {
            buttons[i].setTitle(quizChoices![i].choice, forState: .Normal)
            buttons[i].tag = quizChoices![i].isRightChoice!
            buttons[i].layer.cornerRadius = 5
            buttons[i].layer.borderWidth = 1
            buttons[i].layer.borderColor = UIColor.whiteColor().CGColor
        }
        questionImg.image = UIImage(named:quizImg!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSelectionButtonTap(sender: AnyObject) {
        print(sender.tag)
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
