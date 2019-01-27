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
    
    func setNewActivity(activityType: String, title: String) {
        let activity = NSUserActivity(activityType: activityType)
        activity.title = title
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(activityType)
        } else {
            print("Update your device dude, dafuq!")
        }
        view.userActivity = activity
        activity.becomeCurrent()
        
        //getCommandToTrigger(command: activity.title!)
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
    
    func initializeAllCommands() {
        setNewActivity(activityType: "de.uhh.mlabdewertokin.startHeadUp", title: "Move Head Up")
        setNewActivity(activityType: "de.uhh.mlabdewertokin.startHeadDown", title: "Move Head Down")
        setNewActivity(activityType: "de.uhh.mlabdewertokin.startFeetUp", title: "Move Feet Up")
        setNewActivity(activityType: "de.uhh.mlabdewertokin.startFeetDown", title: "Move Feet Down")
        setNewActivity(activityType: "de.uhh.mlabdewertokin.triggerMemory1", title: "Trigger Memory 1")
        setNewActivity(activityType: "de.uhh.mlabdewertokin.triggerMemory2", title: "Trigger Memory 2")
        
        setNewActivity(activityType: "de.uhh.mlabdewertokin.stopHeadUp", title: "Stop Head Up")
        setNewActivity(activityType: "de.uhh.mlabdewertokin.stopHeadDown", title: "Stop Head Down")
        setNewActivity(activityType: "de.uhh.mlabdewertokin.stopFeetUp", title: "Stop Feet Up")
        setNewActivity(activityType: "de.uhh.mlabdewertokin.stopFeetDown", title: "Stop Feet Down")
    }
    
    func intermediateHelper() {
        print("it works")
    }
    
}
