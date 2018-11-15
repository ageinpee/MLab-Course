//
//  addReminder.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 14.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import UserNotifications
import NotificationCenter

class addReminder: UIViewController {
    
    public var reminderTime = [Int]()
    public var reminderName = [String]()
    public var reminderDescription = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addReminder(){
        print("Reminder added successfully")
    }
    
    @IBAction func addReminderWasCanceled(segue: UIStoryboardSegue){
        print("Unwinding to Reminders Storyboard")
    }
    
    func notificationCenter(){
        // Set the current notification center
    }
    
}
