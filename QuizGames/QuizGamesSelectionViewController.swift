//
//  QuizGamesSelectionViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/23/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit

class QuizGamesSelectionViewController: UIViewController {
    
    @IBOutlet weak var carsQuizButton: UIButton!
    @IBOutlet weak var logosQuizButton: UIButton!
    @IBOutlet weak var citiesQuizButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        carsQuizButton.layer.cornerRadius = 5
        carsQuizButton.layer.borderWidth = 1
        carsQuizButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        logosQuizButton.layer.cornerRadius = 5
        logosQuizButton.layer.borderWidth = 1
        logosQuizButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        citiesQuizButton.layer.cornerRadius = 5
        citiesQuizButton.layer.borderWidth = 1
        citiesQuizButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCarsQuizTap(sender: AnyObject) {
        performSegueWithIdentifier("cars", sender: sender)
    }
    
    @IBAction func onLogosQuizTap(sender: AnyObject) {
        performSegueWithIdentifier("logos", sender: sender)
    }
    
    @IBAction func onCitiesQuizTap(sender: AnyObject) {
        performSegueWithIdentifier("cities", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let identifier = segue.identifier
        let destVc = (segue.destinationViewController as! QuizPageViewController)
        destVc.quizType = identifier
    }
    
}
