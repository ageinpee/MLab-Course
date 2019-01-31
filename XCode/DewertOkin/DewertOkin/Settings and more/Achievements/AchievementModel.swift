//
//  AchievementsTracker.swift
//  DewertOkin
//
//  Created by Jan Robert on 01.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UserNotifications

// ADDING A ACHIEVEMENT:
// 1.Add the achievment to the achievementDictionary in appropriate form,
// 2.aswell as the , resetAchievements() dictionary AND, IMPORTANT: add the type --
// 3.IMPORTANT: add the type in AchievementsTableViewController.let achievementTypes: [AchievementType] --


class AchievementModel {
    
    static var apprenticeCount: Float = 25.0 {
        didSet {
            achievementDictionary[.exerciseApprentice]?.progress = Float(apprenticeCount / 25.0)
            saveAchievementProgress()
        }
    }
    
    static var maniacCount: Float = 25.0 {
        didSet {
            achievementDictionary[.exerciseManiac]?.progress = Float(maniacCount / 50.0)
            saveAchievementProgress()
        }
    }
    
    static var masterCount: Float = 25.0 {
        didSet {
            achievementDictionary[.exerciseMaster]?.progress = Float(masterCount / 100.0)
            saveAchievementProgress()
        }
    }
    
    static var remindersSet: Float = 0.0 {
        didSet {
            achievementDictionary[.onTopOfThings]?.progress = Float(remindersSet / 3.0)
            saveAchievementProgress()
        }
    }
    
    static var timeSpentInAchievementsSection: Float = 0.0 {
        didSet {
            achievementDictionary[.veteran]?.progress = Float(timeSpentInAchievementsSection / 600.0)
        }
    }
    
    static var veteranUnlocked = false
    
    static var apprenticeUnlocked = false {
        didSet {
            if apprenticeUnlocked {
                //displayLocalNotification(forAchievement: "Exercise Apprentice")
            }
        }
    }
    
    static var nightOwlUnlocked = false {
        didSet {
            if nightOwlUnlocked {
                achievementDictionary[.nightOwl]?.progress = Float(1.0)
                saveAchievementProgress()
            }
        }
    }
    
    public static var achievementDictionary: [AchievementType:Achievement] = [
        .exerciseApprentice : Achievement(id: 1, title: "Exercise Apprentice", description: "Do your exercise 25 times", image: "lock_simple", type: .exerciseApprentice, progress: 1.0),
        .exerciseManiac : Achievement(id: 2, title: "Exercise Maniac", description: "Do your exercise 50 times", image: "lock_simple", type: .exerciseManiac, progress: 0.5),
        .exerciseMaster : Achievement(id: 3, title: "Exercise Master", description: "Do your exercise 100 times", image: "lock_simple", type: .exerciseMaster, progress: 0.25),
        .firstStreak : Achievement(id: 4, title: "First Streak!", description: "Do your exercise for 25 times in a row!", image: "lock_simple", type: .firstStreak, progress: 0.0),
        .streakItHard : Achievement(id: 5, title: "Streak it hard!", description: "Do your exercise for 50 times in a row!", image: "lock_simple", type: .streakItHard, progress: 0.0),
        .streakLikeABoss : Achievement(id: 6, title: "STREAK LIKE A BOSS!", description: "Do your exercise for 100 times in a row", image: "lock_simple", type: .streakLikeABoss, progress: 0.0),
        .onTopOfThings : Achievement(id: 7, title: "On Top of Things", description: "Set 3 Reminders", image: "lock_simple", type: .onTopOfThings, progress: 0.0),
        .veteran : Achievement(id: 8, title: "Achievement Veteran", description: "Spend 10 minutes in the Achievements Screen", image: "lock_simple", type: .veteran, progress: 0.0),
        .nightOwl : Achievement(id: 9, title: "Night Owl", description: "Set a timer to trigger between midnight and 4 a.m.", image: "lock_simple", type: .nightOwl, progress: 0.0)

    ]
    
    static func saveAchievementProgress() {
        
        let defaults = UserDefaults.standard
        
        defaults.set(try? PropertyListEncoder().encode(AchievementModel.achievementDictionary), forKey: "dictionary")
        
        defaults.setValue(remindersSet, forKey: "remindersSet")
        defaults.setValue(timeSpentInAchievementsSection, forKey: "timeSpentInAchievementsSection")
        defaults.setValue(veteranUnlocked, forKey: "veteranUnlocked")
        defaults.setValue(nightOwlUnlocked, forKey: "nightOwlUnlocked")
        // Changed for mock
//        defaults.setValue(apprenticeCount, forKey: "apprenticeCount")
//        defaults.setValue(maniacCount, forKey: "maniacCount")
//        defaults.setValue(masterCount, forKey: "masterCount")
        defaults.setValue(25, forKey: "apprenticeCount")
        defaults.setValue(25, forKey: "maniacCount")
        defaults.setValue(25, forKey: "masterCount")
        defaults.setValue(true, forKey: "apprenticeUnlocked")
    }
    
    static func loadAchievementProgress() {
        if let data: Data = UserDefaults.standard.object(forKey: "dictionary") as? Data {
            if let dict: [AchievementType:Achievement] = try? PropertyListDecoder().decode([AchievementType:Achievement].self, from: data) {
                AchievementModel.achievementDictionary = dict
            }
            
            let defaults = UserDefaults.standard

            if let savedRemindersSet = defaults.object(forKey: "remindersSet") as? Float {
                remindersSet = savedRemindersSet
            }
            
            // Removed for mock
//            if let savedApprenticeCount = defaults.object(forKey: "apprenticeCount") as? Float {
//                apprenticeCount = 25.0
//            }
            apprenticeCount = 25.0
            
            // Removed for mock
//            if let savedApprenticeUnlocked = defaults.object(forKey: "savedApprenticeUnlocked") as? Bool {
//                apprenticeUnlocked = true
//            }
            
            if let savedManiacCount = defaults.object(forKey: "maniacCount") as? Float {
                maniacCount = savedManiacCount
            }
            
            if let savedMasterCount = defaults.object(forKey: "masterCount") as? Float {
                masterCount = savedMasterCount
            }
            
            if let savedTimeSpentInAchievementsSection = defaults.object(forKey: "timeSpentInAchievementsSection") as? Float {
                timeSpentInAchievementsSection = savedTimeSpentInAchievementsSection
            }
            if let savedVeteranUnlocked = defaults.object(forKey: "veteranUnlocked") as? Bool {
                veteranUnlocked = savedVeteranUnlocked
            }
            if let savedNightOwlUnlocked = defaults.object(forKey: "nightOwlUnlocked") as? Bool {
                nightOwlUnlocked = savedNightOwlUnlocked
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
    
    public static func registerNewExercise() {
        apprenticeCount += 1
        maniacCount += 1
        masterCount += 1
        print("registering new exercise")
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
           // displayLocalNotification(forAchievement: "Veteran")
            print("Veteran achievement unlocked")
            achievementDictionary[.veteran]?.image = "trophy"
        }
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
    
    public static func resetAchievements() {
        remindersSet = 0
        timeSpentInAchievementsSection = 0
        veteranUnlocked = false
        nightOwlUnlocked = false
        
        achievementDictionary = [
            .exerciseApprentice : Achievement(id: 1, title: "Exercise Apprentice", description: "Do your exercise 25 times", image: "lock_simple", type: .exerciseApprentice, progress: 1.0),
            .exerciseManiac : Achievement(id: 2, title: "Exercise Maniac", description: "Do your exercise 50 times", image: "lock_simple", type: .exerciseManiac, progress: 0.5),
            .exerciseMaster : Achievement(id: 3, title: "Exercise Master", description: "Do your exercise 100 times", image: "lock_simple", type: .exerciseMaster, progress: 0.25),
            .firstStreak : Achievement(id: 4, title: "First Streak!", description: "Do your exercise for 25 times in a row!", image: "lock_simple", type: .firstStreak, progress: 0.0),
            .streakItHard : Achievement(id: 5, title: "Streak it hard!", description: "Do your exercise for 50 times in a row!", image: "lock_simple", type: .streakItHard, progress: 0.0),
            .streakLikeABoss : Achievement(id: 6, title: "STREAK LIKE A BOSS!", description: "Do your exercise for 100 times in a row", image: "lock_simple", type: .streakLikeABoss, progress: 0.0),
            .onTopOfThings : Achievement(id: 7, title: "On Top of Things", description: "Set 3 Reminders", image: "lock_simple", type: .onTopOfThings, progress: 0.0),
            .veteran : Achievement(id: 8, title: "Achievement Veteran", description: "Spend 10 minutes in the Achievements Screen", image: "lock_simple", type: .veteran, progress: 0.0),
            .nightOwl : Achievement(id: 9, title: "Night Owl", description: "Set a timer to trigger between midnight and 4 a.m.", image: "lock_simple", type: .nightOwl, progress: 0.0)
        ]
        
        saveAchievementProgress()
        print("Achievements reset.")
    }
    
}

enum AchievementType: String, Hashable, Codable {
    
    case buttonManiac
    case onTopOfThings
    case veteran
    case undecisive
    case nightOwl
    case exerciseApprentice
    case exerciseManiac
    case exerciseMaster
    case firstStreak
    case streakItHard
    case streakLikeABoss
}

struct Achievement: Codable {
    // Establishes the basic Structure of achievements with the type of the variables
    var id: Int
    var title: String
    var description: String
    var image: String
    var type: AchievementType
    var progress: Float
}
