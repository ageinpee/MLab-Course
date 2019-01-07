//
//  ActivityTracker+Helpers.swift
//  DewertOkin
//
//  Created by Jan Robert on 07.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension ActivityTrackerViewController {
    
    func addAnimation(for cell: UICollectionViewCell) {
        // Initialization code
        let center = CGPoint(x: cell.bounds.midX, y: cell.bounds.midY)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: cell.bounds.height / 3, startAngle: -CGFloat.pi/2, endAngle: -CGFloat.pi/2-0.0001, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineCap = .round
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.lineCap = .round
        trackLayer.strokeColor = UIColor.init(white: 0.95, alpha: 0.95).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 16
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.strokeEnd = 0
        
        cell.layer.addSublayer(trackLayer)
        cell.layer.addSublayer(shapeLayer)
    }
    
    @objc
    func startCircleAnimation(from value: Double = 0) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = value
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(exactly: remainingTimeInSeconds) ?? 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    func displayForegroundActivityReminderNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Your Activity Reminder"
        content.body = "It's time to get up!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let identifier = "activityReminderForeground"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func addBackgroundActivityReminderNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Your Activity Reminder"
        content.body = "It's time to get up!"
        content.sound = UNNotificationSound.default
        
        let timerFinishesTime = Date().addingTimeInterval(remainingTimeInSeconds)
        var dateComponent = DateComponents()
        dateComponent.hour = Calendar(identifier: .gregorian).component(.hour, from: timerFinishesTime)
        dateComponent.minute = Calendar(identifier: .gregorian).component(.minute, from: timerFinishesTime)
        dateComponent.second = Calendar(identifier: .gregorian).component(.second, from: timerFinishesTime)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let identifier = "activityReminderBackground"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
}
