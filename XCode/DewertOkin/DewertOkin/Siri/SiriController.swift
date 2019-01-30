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
    
    func startHeadUp() {
        //guard bluetoothBackgroundHandler.checkStatus() else { return }
//        self.characteristic = self.bluetooth.writeCharacteristic
        bluetoothTimer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { self.changeImage(state: "Right-Up")})
//        bluetoothTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
//            (_) in
//            self.triggerCommand(keycode: keycode.m1In)
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
            self.bluetoothTimer?.invalidate()
            self.resetImage()
        })
    }
    
    func startHeadDown() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        bluetoothTimer?.invalidate()
        changeImage(state: "Right-Down")
        bluetoothTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            (_) in
            self.triggerCommand(keycode: keycode.m1Out)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
            self.bluetoothTimer?.invalidate()
            self.resetImage()
        })
    }
    
    func startFeetUp() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        bluetoothTimer?.invalidate()
        changeImage(state: "Left-Up")
        bluetoothTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            (_) in
            self.triggerCommand(keycode: keycode.m2In)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
            self.bluetoothTimer?.invalidate()
            self.resetImage()
        })
    }
    
    func startFeetDown() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        bluetoothTimer?.invalidate()
        changeImage(state: "Left-Down")
        bluetoothTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            (_) in
            self.triggerCommand(keycode: keycode.m2Out)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
            self.bluetoothTimer?.invalidate()
            self.resetImage()
        })
    }
    
    func triggerMemory1() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        bluetoothTimer?.invalidate()
        bluetoothTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            (_) in
            self.triggerCommand(keycode: keycode.memory1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {self.bluetoothTimer?.invalidate()})
    }
    
    func triggerMemory2() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        bluetoothTimer?.invalidate()
        bluetoothTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            (_) in
            self.triggerCommand(keycode: keycode.memory2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {self.bluetoothTimer?.invalidate()})
    }
    
    func stopHeadUp() {
        bluetoothTimer?.invalidate()
        resetImage()
    }
    
    func stopHeadDown() {
        bluetoothTimer?.invalidate()
        resetImage()
    }
    
    func stopFeetUp() {
        bluetoothTimer?.invalidate()
        resetImage()
    }
    
    func stopFeetDown() {
        bluetoothTimer?.invalidate()
        resetImage()
    }
}
