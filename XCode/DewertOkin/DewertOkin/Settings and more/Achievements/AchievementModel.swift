//
//  AchievementsTracker.swift
//  DewertOkin
//
//  Created by Jan Robert on 01.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation

class AchievementModel {
    
    private static var barButtonClickCount = 0.0
    public static var barButtonClickCountProgess: Float {
        return Float(barButtonClickCount / 5.0)
    }
    
    private static var remindersSet = 0.0
    public static var reminderSetProgress: Float {
        return Float(remindersSet / 3.0)
    }
    
    private static var timeSpentInApp = 0.0
    public static var timeSpentInAppProgress: Float {
        return Float(timeSpentInApp / 600.0)
    }
    
    private static var upDownClickCount = 0
    public static var upDownClickCountUnlocked = Float(0.0)
    
    // Array(struct) of all the achievements in Section 1 of the achievementssection
    // Change these to change the actual displayed Achievement-Label-Text
    public static var achievementCollection1: [Achievement] = [
        Achievement(id: 1, title: "Button Maniac", description: "Clicked the BarButton 5 times", progress: "5/7undefined", image: "lock"),
        Achievement(id: 2, title: "On Top of Things", description: "Set 3 Reminders", progress: "5/7undefined", image: "lock"),
        Achievement(id: 3, title: "Achievement Veteran", description: "Spend 10 minutes in the Achievements Screen", progress: "5/7undefined", image: "lock"),
        Achievement(id: 4, title: "Undecisive", description: "Alternate between up and down 8 times", progress: "5/7undefined", image: "lock"),
        Achievement(id: 5, title: "Night Owl", description: "Set a timer to trigger between midnight and 4 a.m.", progress: "5/7undefined", image: "lock"),
        Achievement(id: 6, title: "achievement6", description: "descriptor6", progress: "5/7undefined", image: "LockedTrophy")
    ]
    // Array(struct) of all the achievements in Section 2 of the achievementssection
    // Change these to change the actual displayed Achievement-Label-Text
    public static var achievementCollection2: [Achievement] = [
        Achievement(id: 1, title: "achievementsec21", description: "descriptor1", progress: "5/7undefined", image: "LockedTrophy"),
        Achievement(id: 2, title: "achievement2", description: "descriptor2", progress: "5/7undefined", image: "LockedTrophy"),
        Achievement(id: 3, title: "achievement3", description: "descriptor3", progress: "5/7undefined", image: "LockedTrophy"),
        Achievement(id: 4, title: "achievement4", description: "descriptor4", progress: "5/7undefined", image: "LockedTrophy"),
        Achievement(id: 5, title: "achievement5", description: "descriptor5", progress: "5/7undefined", image: "LockedTrophy"),
        Achievement(id: 6, title: "achievement6", description: "descriptor6", progress: "5/7undefined", image: "LockedTrophy")
    ]
    
    public static func updateButtonClickCount() {
        barButtonClickCount = barButtonClickCount + 1
        
        if barButtonClickCount == 5 {
            // Notification triggern
            print("BarButton Achievement Triggered")
            achievementCollection1[0].image = "trophy"
        }
    }
    
    public static func updateRemindersSet() {
        remindersSet = remindersSet + 1
        
        if remindersSet == 3 {
            // Notification triggern
            print("Reminder Achievement Triggered")
            achievementCollection1[1].image = "trophy"
        }
    }
    
    public static func updateTimeSpentInAchievements(elapsedTime: TimeInterval) {
        timeSpentInApp = timeSpentInApp + elapsedTime
        
        // Has to be exactly 10
        if (timeSpentInApp >= 600.0) {
            print("Veteran achievement unlocked")
            achievementCollection1[2].image = "trophy"
        }
    }
    
    // Has to be called from RemoteViewController
    public static func undecisiveAchievementUnlocked() {
        achievementCollection1[3].image = "trophy"
        upDownClickCountUnlocked = Float(1.0)
        print("Undecisive achievement unlocked")
    }
    
}


