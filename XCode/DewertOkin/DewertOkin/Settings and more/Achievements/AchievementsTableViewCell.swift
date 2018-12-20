//
//  AchievementsTableViewCell.swift
//  DewertOkin
//
//  Created by Jan Robert on 19.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell, Themeable {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var achievementImage: UIImageView!
        
    //let shapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Themes.setupTheming(for: self)
        // Initialization code
//        let center = CGPoint(x: 1.8 * self.frame.midX, y: self.frame.midY)
//
//        let circularPath = UIBezierPath(arcCenter: center, radius: 35, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
//        shapeLayer.path = circularPath.cgPath
//        shapeLayer.strokeColor = UIColor.red.cgColor
//        shapeLayer.lineCap = .round
//
//        let trackLayer = CAShapeLayer()
//        trackLayer.path = circularPath.cgPath
//        trackLayer.strokeColor = UIColor.red.cgColor
//        trackLayer.lineCap = .round
//        trackLayer.strokeColor = UIColor.lightGray.cgColor
//        trackLayer.fillColor = UIColor.clear.cgColor
//        trackLayer.lineWidth = 2
//
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineWidth = 5
//        shapeLayer.strokeEnd = 0
//
//        self.layer.addSublayer(trackLayer)
//        self.layer.addSublayer(shapeLayer)
//
//        //achievementImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//        handleTap()
        
    }
    
//    @objc
//    private func handleTap() {
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
//        basicAnimation.duration = 2
//        basicAnimation.fillMode = .forwards
//        basicAnimation.isRemovedOnCompletion = false
//        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
