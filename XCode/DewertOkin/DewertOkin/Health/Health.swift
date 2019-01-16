//
//  Health.swift
//  DewertOkin
//
//  Created by Jan Robert on 12.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import HealthKit
import UserNotifications
import BLTNBoard

class Health {
    
    static let shared = Health()
    
    // Save in UserDefaults
    var activityReminderEnabled = false {
        didSet {
            startActivityTracking()
        }
    }
    
    private init() {
        
    }
    
    // Needs to be set somewhere in the Bluetooth class
    var lastBluetoothConnection: Date?
    var lastBluetoothDisconnect: Date?
    
    var lastBluetoothConnectionMock: Date = Date().addingTimeInterval(-1800)
    var lastBluetoothDisconnectMock: Date = Date().addingTimeInterval(-900)
    
    var activityReminderTimeIntervalInMinutes = 60
    
    var activityTimer: Timer?
    
    var exerciseHistory: [ExerciseEvent] = [
        // 7 is saturday
        // 1 is sunday
        ExerciseEvent(time: Date().addingTimeInterval(-31600), completed: true),
        ExerciseEvent(time: Date().addingTimeInterval(-150000), completed: false),
        ExerciseEvent(time: Date().addingTimeInterval(-100200), completed: false),
        ExerciseEvent(time: Date(), completed: false),
        ExerciseEvent(time: Date().addingTimeInterval(-240000), completed: true),
        ExerciseEvent(time: Date().addingTimeInterval(-244800), completed: true)
    ]
    
    lazy var page: BLTNPageItem = {
        let page = BLTNPageItem(title: "Exercise")
        page.image = UIImage(named: "Arch-Exercise")
        page.descriptionText = "Your companion recommends you the following Workout:"
        page.actionButtonTitle = "Do Workout"
        page.alternativeButtonTitle = "Maybe Later"
        
        page.actionHandler = { (item: BLTNActionItem) in
            self.exerciseHistory.append(ExerciseEvent(time: Date(), completed: true))
            print("Action button tapped")
        }
        
        page.alternativeHandler = { (item: BLTNActionItem) in
            print("Maybe later tapped")
            self.bulletinManager.dismissBulletin()
            self.exerciseHistory.append(ExerciseEvent(time: Date(), completed: false))
        }
        
        return page
    }()
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = page
        let manager = BLTNItemManager(rootItem: rootItem)
        manager.backgroundViewStyle = .dimmed
        return manager
    }()
    
    let healthStore = HKHealthStore()
    
    // if tracking is enabled, start this at application launch
    func startActivityTracking() {
        if activityReminderEnabled {
            // Check every 5 minutes, if the user is still sitting down
            // and if the lastBluetoothConnection is longer ago than the activity reminder interval
            activityTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true, block: { (timer) in
                Health.shared.checkActivity(timeInterval: TimeInterval(self.activityReminderTimeIntervalInMinutes * 60), completion: { (HealthCheckReturnValue) in
                    switch HealthCheckReturnValue {
                    case .noActivity:
                        self.displayLocalNotification(with: "Low activity recognized. Standing up regularly improves your health! 🚴‍♂️")
                        guard let currentlyDisplayingVC = UIApplication.shared.keyWindow?.rootViewController else {return}
                        self.showActivityReminder(above: currentlyDisplayingVC)
                        print("No Activity")
                    case .enoughActivity:
                        self.displayLocalNotification(with: "Enough activity. 😇")
                        print("Enough activity")
                    case .error:
                        print("Error")
                    }
                })
            })
        } else {
            activityTimer?.invalidate()
        }
    }
    
    
    func checkActivity(timeInterval: TimeInterval, completion: @escaping (HealthCheckReturnValue) -> Void) {
        // 1. Check if steps in timeInterval are below 50
        // 2. Check if the last Bluetooth connection happened longer than timeInterval ago
        // If both are true: Display Activity Reminder
        checkSteps(timeInterval: timeInterval) { (activity) in
            switch activity {
            case .noActivity:
                // timeInterval is the activity reminder time, difference will be negative
                if self.lastBluetoothConnectionMock.timeIntervalSinceNow < timeInterval {
                    completion(.noActivity)
                } else {
                    // User didn't take enough steps yet, but last BLE connection is not long enough ago
                    completion(.enoughActivity)
                }
            case .enoughActivity:
                completion(.enoughActivity)
            case .error:
                completion(.error)
            }
        }
    }
    
    func requestHealthKitPermission() {
        let healthKitTypes: Set = [
            // access step count
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        ]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (_, _) in
            print("Authorized ?")
        }
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if let e = error {
                print("Something went wrong during authorisation \(e.localizedDescription)")
            } else {
                print("User has completed the authorization flow")
            }
        }
    }
    
    func getStepsForTimeInterval(timeInSeconds: TimeInterval, completion: @escaping (Double?) -> Void) {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let secondsAgo = Date().addingTimeInterval(-timeInSeconds)
        let predicate = HKQuery.predicateForSamples(withStart: secondsAgo, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount: Double? = nil
            guard let result = result else {
                print("Failed to fetch steps rate")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }
    
    func checkSteps(timeInterval: TimeInterval, completion: @escaping (HealthCheckReturnValue) -> Void) {
        guard healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!) == .sharingAuthorized else {
            print("Error fetching Step Data")
            completion(HealthCheckReturnValue.error)
            return
        }
        
        guard activityReminderEnabled else {
            print("Health Recommendations are disabled.")
            completion(.error)
            return
        }
        
        getStepsForTimeInterval(timeInSeconds: timeInterval) { result in
            if let result = result {
                print(result)
                if result < 50 {
                    print("Low activity: Steps below 50")
                    completion(HealthCheckReturnValue.noActivity)
                } else {
                    print("Enough activity: Steps above 50")
                    completion(HealthCheckReturnValue.enoughActivity)
                }
            } else {
                print("Step Data are nil.")
                completion(.error)
            }
        }
    }
    
    private func displayLocalNotification(with text: String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Activity Reminder"
        content.body = text
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "activityReminder"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    
    
    func showActivityReminder(above viewcontroller: UIViewController) {
        bulletinManager.showBulletin(above: viewcontroller)
    }
    
    /**
     Returns the amount of steps for the last 24 hours in 1 hour intervals
     
     - Parameter completion: Completion closure gets executed once the data have been fetched from the HealthStore
     - Returns: An array of stepcounts, ordered from oldest to most recent
     */
    func getLastDaysStepsInHourIntervals(completion: @escaping ([Double]) -> Void) {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            print("Unable to get Step Count.")
            return
        }
        
        var interval = DateComponents()
        interval.hour = 1
        
        let calendar = Calendar.current
        let anchorDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
        
        let query = HKStatisticsCollectionQuery(quantityType: stepCountType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval)
        
        query.initialResultsHandler = { query, results, error in
            
            let startDate = Date().addingTimeInterval(-12*60*60)
            
            var stepsArray: [Double] = []
            
            results?.enumerateStatistics(from: startDate, to: Date(), with: { result, stop  in
                print("Time: \(result.startDate), \(result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0)")
                stepsArray.append(result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0)
            })
            DispatchQueue.main.async {
                completion(stepsArray)
            }

            
        }
        healthStore.execute(query)
    }
    
    
}

enum HealthCheckReturnValue {
    case noActivity
    case enoughActivity
    case error
}

struct ExerciseEvent {
    var time: Date
    var completed: Bool
}
