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
        questionImg.kf_setImageWithURL(NSURL(string: quizImg!)!, placeholderImage: nil,
                                       optionsInfo: nil,
                                       progressBlock: { (receivedSize, totalSize) -> () in
            },
                                       completionHandler: { (image, error, cacheType, imageURL) -> () in
                                        if let quizPageVC = self.parentViewController?.parentViewController as? QuizPageViewController {
                                            if quizPageVC.timedQuiz == 1 {
                                                quizPageVC.restartTimer()
                                            }
                                        }
        })
        
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
    
}
