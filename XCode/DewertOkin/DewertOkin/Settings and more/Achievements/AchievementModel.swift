//
//  AchievementsTracker.swift
//  DewertOkin
//
//  Created by Jan Robert on 01.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UserNotifications

class AchievementModel {
    
    private static var barButtonClickCount = 0.0  {
        didSet {
            achievementDictionary[.buttonManiac]?.progress = Float(barButtonClickCount / 5.0)
        }
    }
    
    private static var remindersSet = 0.0 {
        didSet {
            achievementDictionary[.onTopOfThings]?.progress = Float(remindersSet / 3.0)
        }
    }
    
    private static var timeSpentInApp = 0.0 {
        didSet {
            achievementDictionary[.veteran]?.progress = Float(timeSpentInApp / 600.0)
        }
    }
    
    private static var upDownClickCountUnlocked = false {
        didSet {
            if upDownClickCountUnlocked {
                achievementDictionary[.undecisive]?.progress = Float(1.0)
            }
        }
    }
    
    private static var nightOwlUnlocked = false {
        didSet {
            if nightOwlUnlocked {
                achievementDictionary[.nightOwl]?.progress = Float(1.0)
            }
        }
    }
    
    private static var letThereBeLightUnlocked = false {
        didSet {
            achievementDictionary[.letThereBeLight]?.progress = Float(1.0)
        }
    }
    
    public static var achievementDictionary: [AchievementType:Achievement] = [
        .buttonManiac : Achievement(id: 1, title: "Button Maniac", description: "Clicked the BarButton 5 times", image: "lock", type: .buttonManiac, progress: 0.0),
        .onTopOfThings : Achievement(id: 2, title: "On Top of Things", description: "Set 3 Reminders", image: "lock", type: .onTopOfThings, progress: 0.0),
        .veteran : Achievement(id: 3, title: "Achievement Veteran", description: "Spend 10 minutes in the Achievements Screen", image: "lock", type: .veteran, progress: 0.0),
        .undecisive : Achievement(id: 4, title: "Undecisive", description: "Alternate between up and down 8 times", image: "lock", type: .undecisive, progress: 0.0),
        .nightOwl : Achievement(id: 5, title: "Night Owl", description: "Set a timer to trigger between midnight and 4 a.m.", image: "lock", type: .nightOwl, progress: 0.0),
        .letThereBeLight : Achievement(id: 6, title: "Let there be light", description: "Switch on light mode after being on the dark side", image: "lock", type: .letThereBeLight, progress: 0.0)
    ]
    
    
    // Array(struct) of all the achievements in Section 1 of the achievementssection
    // Change these to change the actual displayed Achievement-Label-Text
    public static var achievementCollection1: [Achievement] = [
        Achievement(id: 1, title: "Button Maniac", description: "Clicked the BarButton 5 times", image: "lock", type: .buttonManiac, progress: 0.0),
        Achievement(id: 2, title: "On Top of Things", description: "Set 3 Reminders", image: "lock", type: .onTopOfThings, progress: 0.0),
        Achievement(id: 3, title: "Achievement Veteran", description: "Spend 10 minutes in the Achievements Screen", image: "lock", type: .veteran, progress: 0.0),
        Achievement(id: 4, title: "Undecisive", description: "Alternate between up and down 8 times", image: "lock", type: .undecisive, progress: 0.0),
        Achievement(id: 5, title: "Night Owl", description: "Set a timer to trigger between midnight and 4 a.m.", image: "lock", type: .nightOwl, progress: 0.0),
        Achievement(id: 6, title: "Let there be light", description: "Switch on light mode after being on the dark side", image: "lock", type: .letThereBeLight, progress: 0.0)
    ]
    // Array(struct) of all the achievements in Section 2 of the achievementssection
    // Change these to change the actual displayed Achievement-Label-Text
    public static var achievementCollection2: [Achievement] = [
    ]
    
    static func saveAchievementProgress() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(AchievementModel.achievementDictionary), forKey: "dictionary")
        print("Achievement progess saved.")
    }
    
    static func loadAchievementProgress() {
        if let data: Data = UserDefaults.standard.object(forKey: "dictionary") as? Data {
            let dict: [AchievementType:Achievement] = try! PropertyListDecoder().decode([AchievementType:Achievement].self, from: data)
            AchievementModel.achievementDictionary = dict
            print("Achievement progress loaded.")
        } else {
            print("Couldn't load achievement progress.")
        }
    }
    
    // Displays a local notification with the title of the achievement that was unlocked
    private static func displayLocalNotification(forAchievement name: String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Achievement Unlocked!"
        content.body = "You unlocked the \(name) achievement!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "\(name)AchievementUnlocked"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    // Dummy achievement, will be removed
    public static func updateButtonClickCount() {
        barButtonClickCount = barButtonClickCount + 1
        
        if barButtonClickCount == 5 {
            
           // Trigger the notification
            displayLocalNotification(forAchievement: "Button Maniac")
            print("BarButton Achievement Triggered")
            
            // Set the trophy image
            achievementDictionary[.buttonManiac]?.image = "trophy"
        }
    }
    
    // On Top of Things
    public static func updateRemindersSet() {
        remindersSet += 1
        
        if remindersSet == 3 {
            // Notification triggern
            displayLocalNotification(forAchievement: "On Top of Things")
            print("Reminder Achievement Triggered")
            achievementDictionary[.onTopOfThings]?.image = "trophy"
        }
    }
    
    // Veteran
    public static func updateTimeSpentInAchievements(elapsedTime: TimeInterval) {
        timeSpentInApp = timeSpentInApp + elapsedTime
        
        // Has to be exactly 10
        if (timeSpentInApp >= 600.0) {
            displayLocalNotification(forAchievement: "Veteran")
            print("Veteran achievement unlocked")
            achievementDictionary[.veteran]?.image = "trophy"
        }
    }
    
    // Has to be called from RemoteViewController
    // Undecisive
    public static func undecisiveAchievementUnlocked() {
        achievementDictionary[.undecisive]?.image = "trophy"
        upDownClickCountUnlocked = true
        displayLocalNotification(forAchievement: "Undecisive")
        print("Undecisive achievement unlocked")
    }
    
    // Night Owl
    public static func nightOwlAchievementUnlocked() {
        achievementDictionary[.nightOwl]?.image = "trophy"
        nightOwlUnlocked = true
        displayLocalNotification(forAchievement: "Night Owl")
        print("Night Owl achievement unlocked")
    }
    
    // Let there be light
    public static func lightAchievementUnlocked() {
        achievementDictionary[.letThereBeLight]?.image = "trophy"
        letThereBeLightUnlocked = true
        displayLocalNotification(forAchievement: "Let there be Light")
        print("Let there be light achievement unlocked")
    }
    
}


