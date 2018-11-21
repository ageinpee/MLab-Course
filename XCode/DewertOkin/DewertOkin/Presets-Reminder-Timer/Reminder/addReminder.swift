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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneReminder(){
        if !(nameTextfield.text == ""){
            self.performSegue(withIdentifier: "ReminderWasAdded", sender: self)
        } else {
            print("Invalid Name")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let time = timePicker.date
        guard let destination = segue.destination as? Reminders else { return }
        let addReminder = Reminder(context: PersistenceService.context)
        addReminder.reminderName = nameTextfield.text!
        addReminder.reminderDescription = descriptionTextfield.text!
        addReminder.reminderTime = time
        PersistenceService.saveContext()
        destination.reminder.append(addReminder)
        
        }
    
    
    func notificationCenter(){
        // Set the current notification center
    }
    
}
