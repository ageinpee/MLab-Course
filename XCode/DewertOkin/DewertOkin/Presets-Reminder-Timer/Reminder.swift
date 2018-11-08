//
//  Reminder.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 08.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreData

class Reminder {
    var reminderName : String = ""
    var reminderDescription : String = ""
    var reminderTime : Int = 0
    
    func ´init´(){
    
    }
    
    /**
     # saving a new reminder-entity into the database
     Parameters:
     - withName: String --> Name of the Reminder
     - withDescription: String --> Description of the Reminder
     - atTime: Int --> Time when the Reminder should be activated
    */
    func saveNewReminder(withName: String, withDescription: String, atTime: Int) {
        let context = PersistenceService.persistentContainer.viewContext
        let entityName = "Reminder" //Entity in the Datamodel
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return
        }
        let newReminder = NSManagedObject(entity: entity, insertInto: context)
        
        newReminder.setValue(withName, forKey: "reminderName")
        newReminder.setValue(withDescription, forKey: "reminderDescription")
        newReminder.setValue(atTime, forKey: "reminderTime")
        
        //save data
        do {
            try context.save()
            print("Saved: reminderName '\(withName)', reminderDescription '\(withDescription)', reminderTime '\(atTime)'")
        } catch {
            print(error)
        }
    }
    
    
    /**
     #fetching a reminders name by name
     Parameters:
     - withName: String --> the name of the reminder you want to fetch
    */
    func fetchAttribute(withName: String) {
        let context = PersistenceService.persistentContainer.viewContext
        let entityName = "Reminder" //Entity in the Datamodel
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "reminderName = %@", withName)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "reminderName") as! String)
            }
        } catch {
            print("Failed")
        }
    }
    
}
