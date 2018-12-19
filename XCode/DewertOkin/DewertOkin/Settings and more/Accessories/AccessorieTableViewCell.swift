//
//  AccessorieTableViewCell.swift
//  DewertOkin
//
//  Created by Jan Robert on 20.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit

class AccessorieTableViewCell: UITableViewCell, Themeable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        Themes.setupTheming(for: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
    
    func setDarkTheme() {
        backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        titleLabel?.textColor = .white
        descriptionLabel.textColor = .white
    }
    
    func setDefaultTheme() {
        backgroundColor = .white
        titleLabel?.textColor = nil
        descriptionLabel.textColor = nil
    }

}
