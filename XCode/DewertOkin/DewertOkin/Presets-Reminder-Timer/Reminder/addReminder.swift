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
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    private var saved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneReminder(){
        if !(nameTextfield.text == ""){
            saved = true
            self.performSegue(withIdentifier: "ReminderWasAdded", sender: self)
        } else {
            print("Invalid Name")
            // Animation
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? Reminders else { return }
        if(saved){
            let time = timePicker.date
            let addReminder = Reminder(context: PersistenceService.context)
            addReminder.reminderName = nameTextfield.text!
            addReminder.reminderDescription = descriptionTextfield.text!
            addReminder.reminderTime = time
            PersistenceService.saveContext()
            destination.reminder.append(addReminder)
        }
        saved = false
    }
}
