//
//  TopScoresChildViewController.swift
//  QuizGames
//
//  Created by Radoslav on 4/26/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit
import Alamofire

class TopScoresChildViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mIndicator: UIActivityIndicatorView!
    var resultsList: [Result] = []
    var resultsType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2x scale on the indicator
        mIndicator.transform = CGAffineTransformMakeScale(2, 2)
        mIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        mIndicator.startAnimating()
        mIndicator.backgroundColor = UIColor.whiteColor()
        view.bringSubviewToFront(mIndicator)
        
        mTableView.registerClass(TopScoresTableViewCell.self, forCellReuseIdentifier: "groupcell")
        mTableView.delegate = self
        mTableView.dataSource = self
        
        Alamofire.request(.GET, "\(Util.quizGamesAPI)/results/\(resultsType!)", parameters: nil, headers: nil, encoding: .JSON)
            .responseJSON { response in
                // print(response.request)  // original URL request
                // print(response.response) // URL response
                // print(response.data)     // server data
                // print(response.result)   // result of response serialization
                
                if let results = response.result.value {
                    // print("JSON: \(results)")
                    for i in 0 ..< results.count {
                        let result = (results as! NSArray)[i] as! NSDictionary
                        let resultModel = Result()
                        resultModel.name = result["name"] as? String
                        resultModel.score = result["score"] as? Int
                        resultModel.date = result["date"] as? String
                        self.resultsList.append(resultModel)
                    }
                    self.mTableView.reloadData()
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TopScoresTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TopScoresTableViewCell
        
        // Fetches the appropriate scan for the data source layout.
        let result = resultsList[indexPath.row]
        cell.name.text = result.name
        cell.score.text = String(result.score!)
        
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(parseDateTime(result.date!)))
        cell.days.text = date.relativeTime
        
        return cell
    }
    
    func parseDateTime(dtString: String) -> CLong {
        var dateString = dtString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
        if dateString.containsString("T") {
            dateString = dateString.stringByReplacingOccurrencesOfString("T", withString: " ")
        }
        if dateString.containsString("Z") {
            dateString = dateString.stringByReplacingOccurrencesOfString("Z", withString: "+0000")
        }
        
        let date = dateFormatter.dateFromString(dateString)?.timeIntervalSince1970
        return CLong(date!)
    }
    
    
}
