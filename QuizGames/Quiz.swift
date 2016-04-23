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
}
