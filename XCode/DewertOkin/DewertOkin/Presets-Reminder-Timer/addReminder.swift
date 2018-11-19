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
    
    public var reminderName = [String]()
    public var reminderDescription = [String]()
    public var reminderTime = [String]()
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneReminder(){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let time = timePicker.date
        let components = Calendar.current.dateComponents([.hour,.minute],from: time)
        let hour = components.hour!
        var stringHour = ""
        if hour < 10 {
            stringHour = "0" + String(hour)
        } else {
            stringHour = String(hour)
        }
        
        let minute = components.minute!
        var stringMinute = ""
        if minute < 10 {
            stringMinute = "0" + String(minute)
        } else {
            stringMinute = String(minute)
        }
        if let destination = segue.destination as? Reminders {
            destination.reminderTime.append((stringHour + ":" + stringMinute))
            destination.reminderName.append(nameTextfield.text!)
            destination.reminderDescription.append(nameTextfield.text!)
        }
    }
    
    func notificationCenter(){
        // Set the current notification center
    }
    
}
