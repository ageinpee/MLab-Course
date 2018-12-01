//
//  AchievementsTracker.swift
//  DewertOkin
//
//  Created by Jan Robert on 01.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation

class AchievementsTracker {
    
    
    private static var barButtonClickCount = 0
    private static var remindersSet = 0
    private static var presetsCount = 0
    private static var settingsClicked = 0
    private static var timeSpentInApp = 0.0
    
    // Array(struct) of all the achievements in Section 1 of the achievementssection
    // Change these to change the actual displayed Achievement-Label-Text
    public static var achievementCollection1: [Achievement] = [
        Achievement(id: 1, title: "achievement1", description: "descriptor1", progress: "5/7undefined", image: "LockedTrophy"),
        Achievement(id: 2, title: "achievement2", description: "descriptor2", progress: "5/7undefined", image: "LockedTrophy"),
        Achievement(id: 3, title: "achievement3", description: "descriptor3", progress: "5/7undefined", image: "LockedTrophy"),
        Achievement(id: 4, title: "achievement4", description: "descriptor4", progress: "5/7undefined", image: "LockedTrophy"),
        Achievement(id: 5, title: "achievement5", description: "descriptor5", progress: "5/7undefined", image: "LockedTrophy"),
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
        }
    }
    
    public static func updateRemindersSet() {
        remindersSet = remindersSet + 1
        
        if remindersSet == 3 {
            // Notification triggern
            print("Reminder Achievement Triggered")
        }
    }
    
}


