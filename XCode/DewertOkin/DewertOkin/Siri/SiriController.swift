//
//  SiriController.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 25.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import Intents


class SiriController: NSObject {
    
    func moveHeadUpActivity() -> NSUserActivity {
        let activity = NSUserActivity(activityType: "de.uhh.mlabdewertokin.command")
        activity.title = "Move Head Up"
        //activity.userInfo = ["head" : "up"]
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier("de.uhh.mlabdewertokin.command")
        } else {
            // Fallback on earlier versions
        }
        return activity
    }
    
}
