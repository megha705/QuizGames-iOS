//
//  QuizViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/23/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit
import Alamofire

class QuizPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var quizType: String?
    var quizList: [Quiz] = []
    var previousQuizId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    
                    self.dataSource = self
                    self.setViewControllers([self.getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                } else {
                    // register failed
                    
                }
        }
        
        
        
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
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let pageContent: QuizViewController = viewController as! QuizViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1;
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let pageContent: QuizViewController = viewController as! QuizViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1;
        if (index == quizList.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> QuizViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("quizViewController") as! QuizViewController
        let quiz = quizList[index]
        pageContentViewController.quizChoices = quiz.quizChoices
        pageContentViewController.quizImg = quiz.quizImage
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
}
