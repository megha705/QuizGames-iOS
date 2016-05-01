//
//  QuizViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/23/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit
import Alamofire

class QuizPageViewController: UIViewController, UIPageViewControllerDataSource {
    var timedQuiz: Int?
    let MAX_TIME = 20
    let MAX_POINTS = 100
    let MAX_QUESTIONS = 20
    var score = 0
    var correctAnswers = 0
    var elapsedTime = 0
    var timer = NSTimer()
    var quizType: String?
    var quizList: [Quiz] = []
    var previousQuizId = -1
    var pageViewController: UIPageViewController!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var timeleftLabel: UILabel!
    @IBOutlet weak var mIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // title = quizType!
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("quizPageViewController") as! UIPageViewController
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        view.bringSubviewToFront(scoreLabel)
        view.bringSubviewToFront(pageLabel)
        view.bringSubviewToFront(timeleftLabel)
        scoreLabel.hidden = true
        pageLabel.hidden = true
        timeleftLabel.hidden = true
        
        // 2x scale on the indicator
        mIndicator.transform = CGAffineTransformMakeScale(2, 2)
        mIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        mIndicator.startAnimating()
        mIndicator.backgroundColor = UIColor.clearColor()
        view.bringSubviewToFront(mIndicator)
        
        Alamofire.request(.GET, "\(Util.quizGamesAPI)/quiz/\(quizType!)", parameters: nil, headers: nil, encoding: .JSON)
            .responseJSON { response in
                // print(response.request)  // original URL request
                // print(response.response) // URL response
                // print(response.data)     // server data
                // print(response.result)   // result of response serialization
                
                if let results = response.result.value {
                    // print("JSON: \(results)")
                    var quizModel: Quiz?
                    for i in 0 ..< results.count {
                        let result = (results as! NSArray)[i] as! NSDictionary
                        if (result["quiz_id"] as! Int == self.previousQuizId) {
                            let quizChoice = QuizChoice()
                            quizChoice.choice = result["choice"] as? String
                            quizChoice.choiceId = result["choice_id"] as? Int
                            quizChoice.isRightChoice = Int((result["is_right_choice"] as? String)!)
                            
                            if quizModel != nil {
                                quizModel?.addQuizChoice(quizChoice)
                            }
                        } else {
                            if quizModel != nil {
                                self.quizList.append(quizModel!)
                            }
                            self.previousQuizId = result["quiz_id"] as! Int
                            quizModel = Quiz()
                            quizModel?.quizId = result["quiz_id"] as? Int
                            quizModel?.quizImage = result["quiz_image"] as? String
                            quizModel?.quizType = result["quiz_type"] as? String
                            
                            let quizChoice = QuizChoice()
                            quizChoice.choice = result["choice"] as? String
                            quizChoice.choiceId = result["choice_id"] as? Int
                            quizChoice.isRightChoice = Int((result["is_right_choice"] as? String)!)
                            
                            quizModel?.addQuizChoice(quizChoice)
                        }
                        
                    }
                    // Add the last item
                    self.quizList.append(quizModel!)
                    self.quizList.shuffleInPlace()
                    
                    // Disable user scrolling
                    //  self.pageViewController.dataSource = self
                    
                    // Show our labels
                    self.scoreLabel.hidden = false
                    self.pageLabel.hidden = false
                    self.timeleftLabel.hidden = false
                    
                    if self.timedQuiz == 0 {
                        self.timeleftLabel.hidden = true
                    }
                    
                    self.pageViewController.setViewControllers([self.getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                    if self.timedQuiz == 1 {
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(QuizPageViewController.counter), userInfo: nil, repeats: true)
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
                self.mIndicator.stopAnimating()
                self.mIndicator.hidesWhenStopped = true
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func counter() {
        elapsedTime += 1
        if (MAX_TIME-elapsedTime == 0) {
            elapsedTime = 0
            let vc = pageViewController.viewControllers![0] as! QuizContentViewController
            let pageIndex = vc.pageIndex
            if pageIndex == MAX_QUESTIONS - 1 {
                performSegueWithIdentifier("showScore", sender: nil)
            } else {
                self.pageViewController.setViewControllers([self.getViewControllerAtIndex(pageIndex+1)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                // pageIndex starts from zero that's why we add +2
                let questionPosition = String(format: NSLocalizedString("questionPosition", comment: ""), String(pageIndex+2), String(20))
                pageLabel.text = questionPosition
            }
        }
        let timeLeft = String(format: NSLocalizedString("timeLeft", comment: ""), String(MAX_TIME-elapsedTime))
        timeleftLabel.text = timeLeft
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?  {
        let pageContent: QuizContentViewController = viewController as! QuizContentViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        index -= 1;
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController)  -> UIViewController? {
        let pageContent: QuizContentViewController = viewController as! QuizContentViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound) {
            return nil;
        }
        index += 1;
        if (index == MAX_QUESTIONS) {
            return nil;
        }
        return getViewControllerAtIndex(index)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> QuizContentViewController  {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("quizContentViewController") as! QuizContentViewController
        let quiz = quizList[index]
        pageContentViewController.quizChoices = quiz.quizChoices
        pageContentViewController.quizImg = quiz.quizImage
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    // This is called from the child view when the user taps on one of the buttons
    func onSelectionButtonTap(correctAnswer: Int) {
        if correctAnswer == 1 {
            score += (MAX_POINTS / MAX_TIME) * (MAX_TIME - elapsedTime);
            correctAnswers += 1;
            let scoreText = String(format: NSLocalizedString("score", comment: ""), String(score))
            scoreLabel.text = scoreText
        }
        let vc = pageViewController.viewControllers![0] as! QuizContentViewController
        let pageIndex = vc.pageIndex
        if pageIndex == MAX_QUESTIONS - 1 {
            performSegueWithIdentifier("showScore", sender: nil)
        } else {
            elapsedTime = 0
            self.pageViewController.setViewControllers([self.getViewControllerAtIndex(pageIndex+1)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            // pageIndex starts from zero that's why we add +2
            let questionPosition = String(format: NSLocalizedString("questionPosition", comment: ""), String(pageIndex+2), String(20))
            pageLabel.text = questionPosition
            
            let timeLeft = String(format: NSLocalizedString("timeLeft", comment: ""), String(MAX_TIME-elapsedTime))
            timeleftLabel.text = timeLeft
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // stop our timer from firing
        timer.invalidate()
        timer = NSTimer()
        let identifier = segue.identifier
        let destVc = (segue.destinationViewController as! ScoreViewController)
        if identifier == "showScore" {
            destVc.score = score
            destVc.correctAnswers = correctAnswers
            destVc.quizType = quizType
        }
    }
    
    func onSingleAnswerClick(correctAnswer: String, userInput: String) {
        if correctAnswer.lowercaseString == userInput.lowercaseString {
            score += 150;
            correctAnswers += 1;
            let scoreText = String(format: NSLocalizedString("score", comment: ""), String(score))
            scoreLabel.text = scoreText
        }
        let vc = pageViewController.viewControllers![0] as! QuizContentViewController
        let pageIndex = vc.pageIndex
        if pageIndex == MAX_QUESTIONS - 1 {
            performSegueWithIdentifier("showScore", sender: nil)
        } else {
            elapsedTime = 0
            self.pageViewController.setViewControllers([self.getViewControllerAtIndex(pageIndex+1)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            // pageIndex starts from zero that's why we add +2
            let questionPosition = String(format: NSLocalizedString("questionPosition", comment: ""), String(pageIndex+2), String(20))
            pageLabel.text = questionPosition
            
            let timeLeft = String(format: NSLocalizedString("timeLeft", comment: ""), String(MAX_TIME-elapsedTime))
            timeleftLabel.text = timeLeft
        }
        
    }
    
}
