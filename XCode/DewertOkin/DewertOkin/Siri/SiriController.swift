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
    
    @available(iOS 12.0, *)
    func setNewActivity(activityType: String, title: String) -> INShortcut {
        let activity = NSUserActivity(activityType: activityType)
        activity.title = title
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(activityType)
        
        return INShortcut(userActivity: activity)
        
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
        if #available(iOS 12.0, *) {
            var shortcuts = [INShortcut]()
            
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.startHeadUp", title: "Move Head Up"))
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.startHeadDown", title: "Move Head Down"))
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.startFeetUp", title: "Move Feet Up"))
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.startFeetDown", title: "Move Feet Down"))
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.triggerMemory1", title: "Trigger Memory 1"))
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.triggerMemory2", title: "Trigger Memory 2"))
            
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.stopHeadUp", title: "Stop Head Up"))
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.stopHeadDown", title: "Stop Head Down"))
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.stopFeetUp", title: "Stop Feet Up"))
            shortcuts.append(setNewActivity(activityType: "de.uhh.mlabdewertokin.stopFeetDown", title: "Stop Feet Down"))
            
            INVoiceShortcutCenter.shared.setShortcutSuggestions(shortcuts)
            
        } else {
            print("Update your device dude, dafuq!")
        }
    }
    
    func intermediateHelper() {
        print("it works")
    }
    
//    func initializeAllCommands() {
//        setNewActivity(activityType: "de.uhh.mlabdewertokin.startHeadUp", title: "Move Head Up")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { self.setNewActivity(activityType: "de.uhh.mlabdewertokin.startHeadDown", title: "Move Head Down") })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: { self.setNewActivity(activityType: "de.uhh.mlabdewertokin.startFeetUp", title: "Move Feet Up") })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: { self.setNewActivity(activityType: "de.uhh.mlabdewertokin.startFeetDown", title: "Move Feet Down") })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5, execute: { self.setNewActivity(activityType: "de.uhh.mlabdewertokin.triggerMemory1", title: "Trigger Memory 1") })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5, execute: { self.setNewActivity(activityType: "de.uhh.mlabdewertokin.triggerMemory2", title: "Trigger Memory 2") })
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5, execute: { self.setNewActivity(activityType: "de.uhh.mlabdewertokin.stopHeadUp", title: "Stop Head Up") })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5, execute: { self.setNewActivity(activityType: "de.uhh.mlabdewertokin.stopHeadDown", title: "Stop Head Down") })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 8.5, execute: { self.setNewActivity(activityType: "de.uhh.mlabdewertokin.stopFeetUp", title: "Stop Feet Up") })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 9.5, execute: { self.setNewActivity(activityType: "de.uhh.mlabdewertokin.stopFeetDown", title: "Stop Feet Down") })
//    }
    
}
