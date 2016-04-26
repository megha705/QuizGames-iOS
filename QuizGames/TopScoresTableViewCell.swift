//
//  TopScoresTableViewCell.swift
//  QuizGames
//
//  Created by Radoslav on 4/26/16.
//  Copyright © 2016 Sourcestream. All rights reserved.
//

import UIKit

class TopScoresTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var days: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
