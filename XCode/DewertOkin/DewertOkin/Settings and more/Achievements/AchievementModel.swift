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
    
    static var barButtonClickCount: Float = 0.0  {
        didSet {
            achievementDictionary[.buttonManiac]?.progress = Float(barButtonClickCount / 5.0)
        }
    }
    
    static var remindersSet: Float = 0.0 {
        didSet {
            achievementDictionary[.onTopOfThings]?.progress = Float(remindersSet / 3.0)
        }
    }
    
    static var timeSpentInAchievementsSection: Float = 0.0 {
        didSet {
            achievementDictionary[.veteran]?.progress = Float(timeSpentInAchievementsSection / 600.0)
        }
    }
    
    static var veteranUnlocked = false
    
    static var upDownClickCountUnlocked = false {
        didSet {
            if upDownClickCountUnlocked {
                achievementDictionary[.undecisive]?.progress = Float(1.0)
            }
        }
    }
    
    static var nightOwlUnlocked = false {
        didSet {
            if nightOwlUnlocked {
                achievementDictionary[.nightOwl]?.progress = Float(1.0)
            }
        }
    }
    
    static var letThereBeLightUnlocked = false {
        didSet {
            achievementDictionary[.letThereBeLight]?.progress = Float(1.0)
        }
    }
    
    public static var achievementDictionary: [AchievementType:Achievement] = [
        .buttonManiac : Achievement(id: 1, title: "Button Maniac", description: "Clicked the BarButton 5 times", image: "lock_simple", type: .buttonManiac, progress: 0.0),
        .onTopOfThings : Achievement(id: 2, title: "On Top of Things", description: "Set 3 Reminders", image: "lock_simple", type: .onTopOfThings, progress: 0.0),
        .veteran : Achievement(id: 3, title: "Achievement Veteran", description: "Spend 10 minutes in the Achievements Screen", image: "lock_simple", type: .veteran, progress: 0.0),
        .undecisive : Achievement(id: 4, title: "Undecisive", description: "Alternate between up and down 8 times", image: "lock_simple", type: .undecisive, progress: 0.0),
        .nightOwl : Achievement(id: 5, title: "Night Owl", description: "Set a timer to trigger between midnight and 4 a.m.", image: "lock_simple", type: .nightOwl, progress: 0.0),
        .letThereBeLight : Achievement(id: 6, title: "Let there be light", description: "Switch on light mode after being on the dark side", image: "lock_simple", type: .letThereBeLight, progress: 0.0)
    ]
    
    static func saveAchievementProgress() {
        
        let defaults = UserDefaults.standard
        
        defaults.set(try? PropertyListEncoder().encode(AchievementModel.achievementDictionary), forKey: "dictionary")
        
        defaults.setValue(barButtonClickCount, forKey: "barButtonClickCount")
        defaults.setValue(remindersSet, forKey: "remindersSet")
        defaults.setValue(timeSpentInAchievementsSection, forKey: "timeSpentInAchievementsSection")
        defaults.setValue(veteranUnlocked, forKey: "veteranUnlocked")
        defaults.setValue(upDownClickCountUnlocked, forKey: "upDownClickCountUnlocked")
        defaults.setValue(nightOwlUnlocked, forKey: "nightOwlUnlocked")
        defaults.setValue(letThereBeLightUnlocked, forKey: "letThereBeLightUnlocked")
        
        print("Achievement progess saved.")
    }
    
    static func loadAchievementProgress() {
        if let data: Data = UserDefaults.standard.object(forKey: "dictionary") as? Data {
            let dict: [AchievementType:Achievement] = try! PropertyListDecoder().decode([AchievementType:Achievement].self, from: data)
            AchievementModel.achievementDictionary = dict
            
            let defaults = UserDefaults.standard
            
            if let savedBarButtonClickCount = defaults.object(forKey: "barButtonClickCount") as? Float {
                barButtonClickCount = savedBarButtonClickCount
            }
            if let savedRemindersSet = defaults.object(forKey: "remindersSet") as? Float {
                remindersSet = savedRemindersSet
            }
            if let savedTimeSpentInAchievementsSection = defaults.object(forKey: "timeSpentInAchievementsSection") as? Float {
                timeSpentInAchievementsSection = savedTimeSpentInAchievementsSection
            }
            if let savedVeteranUnlocked = defaults.object(forKey: "veteranUnlocked") as? Bool {
                veteranUnlocked = savedVeteranUnlocked
            }
            if let savedUpDownClickCountUnlocked = defaults.object(forKey: "upDownClickCountUnlocked") as? Bool {
                upDownClickCountUnlocked = savedUpDownClickCountUnlocked
            }
            if let savedNightOwlUnlocked = defaults.object(forKey: "nightOwlUnlocked") as? Bool {
                nightOwlUnlocked = savedNightOwlUnlocked
            }
            if let savedLetThereBeLightUnlocked = defaults.object(forKey: "letThereBeLightUnlocked") as? Bool {
                letThereBeLightUnlocked = savedLetThereBeLightUnlocked
            }
            
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
    // Doesn't get triggered as long as the Achievements section is on screen.
    // Leaving it will calculate the new value and trigger the Achievement.
    public static func updateTimeSpentInAchievements(elapsedTime: TimeInterval) {
        timeSpentInAchievementsSection = timeSpentInAchievementsSection + Float(elapsedTime)
        
        if (timeSpentInAchievementsSection >= 600.0) {
            displayLocalNotification(forAchievement: "Veteran")
            print("Veteran achievement unlocked")
            achievementDictionary[.veteran]?.image = "trophy"
        }
    }
    
    // Has to be called from RemoteViewController
    // Undecisive
    public static func undecisiveAchievementUnlocked() {
        // TODO: Only trigger if it hasn't been unlocked already
        achievementDictionary[.undecisive]?.image = "trophy"
        upDownClickCountUnlocked = true
        displayLocalNotification(forAchievement: "Undecisive")
        print("Undecisive achievement unlocked")
    }
    
    // Night Owl
    public static func nightOwlAchievementUnlocked() {
        // Only trigger if it hasn't been unlocked already
        if (!nightOwlUnlocked) {
            achievementDictionary[.nightOwl]?.image = "trophy"
            nightOwlUnlocked = true
            displayLocalNotification(forAchievement: "Night Owl")
            print("Night Owl achievement unlocked")
            
        }
    }
    
    // Let there be light
    public static func lightAchievementUnlocked() {
        // Only trigger if it hasn't been unlocked already
        if (!letThereBeLightUnlocked) {
            achievementDictionary[.letThereBeLight]?.image = "trophy"
            letThereBeLightUnlocked = true
            displayLocalNotification(forAchievement: "Let there be Light")
            print("Let there be light achievement unlocked")
        }
    }
    
    public static func resetAchievements() {
        barButtonClickCount = 0
        remindersSet = 0
        timeSpentInAchievementsSection = 0
        veteranUnlocked = false
        upDownClickCountUnlocked = false
        nightOwlUnlocked = false
        letThereBeLightUnlocked = false
        
        achievementDictionary =  [
            .buttonManiac : Achievement(id: 1, title: "Button Maniac", description: "Clicked the BarButton 5 times", image: "lock_simple", type: .buttonManiac, progress: 0.0),
            .onTopOfThings : Achievement(id: 2, title: "On Top of Things", description: "Set 3 Reminders", image: "lock_simple", type: .onTopOfThings, progress: 0.0),
            .veteran : Achievement(id: 3, title: "Achievement Veteran", description: "Spend 10 minutes in the Achievements Screen", image: "lock_simple", type: .veteran, progress: 0.0),
            .undecisive : Achievement(id: 4, title: "Undecisive", description: "Alternate between up and down 8 times", image: "lock_simple", type: .undecisive, progress: 0.0),
            .nightOwl : Achievement(id: 5, title: "Night Owl", description: "Set a timer to trigger between midnight and 4 a.m.", image: "lock_simple", type: .nightOwl, progress: 0.0),
            .letThereBeLight : Achievement(id: 6, title: "Let there be light", description: "Switch on light mode after being on the dark side", image: "lock_simple", type: .letThereBeLight, progress: 0.0)
        ]
        
        saveAchievementProgress()
        print("Achievements reset.")
    }
    
}


