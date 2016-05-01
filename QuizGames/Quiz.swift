//
//  Quiz.swift
//  QuizGames
//
//  Created by Radoslav on 4/23/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit

class Quiz {
    var quizId: Int?
    var quizImage: String?
    var quizType: String?
    var quizChoices: [QuizChoice] = []
    
    func addQuizChoice(quizChoice: QuizChoice) {
        quizChoices.append(quizChoice)
    }
    
    func toJSON() -> NSDictionary {
        var choices: [NSDictionary] = []
        for i in 0 ..< quizChoices.count {
            let choice: NSDictionary = [
                "choiceId" : (quizChoices[i].choiceId ?? 0)!,
                "choice" : quizChoices[i].choice!,
                "isRightChoice" : quizChoices[i].isRightChoice!
            ]
            choices.append(choice)
        }
        
        let quiz: NSDictionary = [
            "quizId" : (quizId ?? 0)!,
            "quizImage": quizImage!,
            "quizType": quizType!,
            "quizChoices": choices
        ]
        
        return quiz
    }
}
