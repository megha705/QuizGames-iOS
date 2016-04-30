//
//  ViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/22/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var topScoresButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playButton.layer.cornerRadius = 5
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        topScoresButton.layer.cornerRadius = 5
        topScoresButton.layer.borderWidth = 1
        topScoresButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        aboutButton.layer.cornerRadius = 5
        aboutButton.layer.borderWidth = 1
        aboutButton.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onLogoutTap(sender: AnyObject) {
        let preferences = NSUserDefaults.standardUserDefaults()
        preferences.setInteger(0, forKey: Util.USER_ID_PREF)
        preferences.setInteger(0, forKey: Util.USER_ROLE_ID)
        self.performSegueWithIdentifier("showLoginView", sender: sender)
    }

}

