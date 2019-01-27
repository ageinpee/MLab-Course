//
//  SiriController.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 25.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import Intents


extension RemoteController {
    
    func moveHeadUpActivity(activityType: String, title: String, userInfo: AnyHashable) {
        let activity = NSUserActivity(activityType: "de.uhh.mlabdewertokin.command")
        activity.title = "Move Head Up"
        activity.userInfo = ["color" : "red"]
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier("de.uhh.mlabdewertokin.command")
        } else {
            // Fallback on earlier versions
        }
        view.userActivity = activity
        activity.becomeCurrent()
        
        getCommandToTrigger(command: activity.title!)
    }
    
    func getCommandToTrigger(command: String) {
        switch command {
            case "Move Head Up": moveHeadUp()
            case "Move Head Down": moveHeadDown()
            case "Move Feet Up": moveFeetUp()
            case "Move Feet Down": moveFeetDown()
            //case "Trigger Memory 1": triggerMemory1()
            //case "Trigger Memory 2": triggerMemory2()
            default: ()
        }
    }
    
}
