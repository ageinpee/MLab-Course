//
//  AchievementsTableViewCell.swift
//  DewertOkin
//
//  Created by Jan Robert on 19.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
