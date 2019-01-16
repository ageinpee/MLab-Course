//
//  AppDelegate.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 28.10.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
//import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    lazy var bluetoothBackgroundHandler = BluetoothBackgroundHandler(bluetoothService: self.bluetooth)
    let defaults = UserDefaults.standard


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) { (granted, error) in
            // Enable or disable features based on authorization.
            if !granted{
            print("You Need To Grant Permission!")
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        // Bluetooth Reconnection stuff
        bluetooth.bluetoothCoordinator = bluetoothFlow
        checkAndReconnectDevice()
        
        UNUserNotificationCenter.current().delegate = self
        AchievementModel.loadAchievementProgress()
        UIApplication.shared.setMinimumBackgroundFetchInterval(600)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainViewController()
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Health.shared.checkSteps { result in
            switch result {
            case .noActivity: completionHandler(.noData)
            case .enoughActivity: completionHandler (.newData)
            case .error: completionHandler(.failed)
            }
        }
        print("Background fetch works!")
    }
    
    // Allows Notifications to be displayed while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // Disconnecting from Device
        if (bluetooth.connectedPeripheral != nil) {
            bluetoothFlow.cancel()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        AchievementModel.saveAchievementProgress()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        AchievementModel.loadAchievementProgress()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Reconnecting to latest Device
        let availablePeripheral = bluetoothBackgroundHandler.reconnect()
        guard availablePeripheral != nil else { return }
        bluetoothFlow.connect(peripheral: availablePeripheral!, completion: { _ in })
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        PersistenceService.saveContext()
        
        // Disconnecting from Device
        if (bluetooth.connectedPeripheral != nil) {
            bluetoothFlow.cancel()
        }
    }
    
    func checkAndReconnectDevice() {
        guard waitForBluetooth() else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.checkAndReconnectDevice() })
            return
        }
        guard bluetooth.connectedPeripheral == nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.checkAndReconnectDevice() })
            return
        }
        let availablePeripheral = bluetoothBackgroundHandler.reconnect()
        guard availablePeripheral != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.checkAndReconnectDevice() })
            return
        }
        bluetoothFlow.connect(peripheral: availablePeripheral!, completion: { _ in })
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { self.checkAndReconnectDevice() })
    }
    
    func waitForBluetooth() -> Bool {
        return bluetooth.centralManager.state == .poweredOn
    }
    
}

