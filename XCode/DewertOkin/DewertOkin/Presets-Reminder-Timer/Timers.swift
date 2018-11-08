//
//  Timer.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 08.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import UserNotifications
import NotificationCenter

class Timers {
    
    public var timerTime : Int!
    public var timerName : String!
    public var timerDescription : String!
    
    func `init`(){
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 50,
                                                        repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
        
    }
    
    func notificationCenter(){
        // Set the current notification center
        let center = UNUserNotificationCenter.current()
        // Actions
        let remindLaterAction = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: UNNotificationActionOptions(rawValue: 0))
        let acceptAction = UNNotificationAction(identifier: "accept", title: "Accept", options: .foreground)
        let declineAction = UNNotificationAction(identifier: "decline", title: "Decline", options: .destructive)
        let commentAction = UNTextInputNotificationAction(identifier: "comment", title: "Comment", options: .authenticationRequired, textInputButtonTitle: "Send", textInputPlaceholder: "Share your thoughts..")
        
        // Category
        let invitationCategory = UNNotificationCategory(identifier: "INVITATION", actions: [remindLaterAction, acceptAction, declineAction, commentAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        
        //Register the app’s notification types and the custom actions that they support.
        center.setNotificationCategories([invitationCategory])
    }
}
