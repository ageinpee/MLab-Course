//
//  Reminder.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 08.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import UserNotifications
import NotificationCenter

class Reminders: UIViewController {
    
    var reminder = [Reminder]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            let reminder = try PersistenceService.context.fetch(fetchRequest)
            self.reminder = reminder
            self.tableView.reloadData()
        } catch {
            print("Couldnt update the TableView, reload!")
        }
    }
    
    @IBAction func addReminder(_ sender: UIStoryboardSegue){
        print("Done button was clicked")
        self.tableView.reloadData()
    }
    
    @IBAction func addReminderWasCanceled(_ sender: UIStoryboardSegue){
        print("Cancel button was clicked")
    }
    
    func notificationCenter(){
        // Set the current notification center
    }
}

extension Reminders: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mySwitch = UISwitch()
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.textLabel?.text = reminder[indexPath.row].reminderName
        cell.detailTextLabel?.text = (reminder[indexPath.row].reminderTime?.toString(dateFormat: "HH:MM"))! + " | " +  reminder[indexPath.row].reminderDescription!
        cell.accessoryView = mySwitch
        mySwitch.setOn(true,animated:true)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.reminder.remove(at: indexPath.row)
            let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
            
            do {
                var savedReminder = try PersistenceService.context.fetch(fetchRequest)
                let managedObectContext = PersistenceService.persistentContainer.viewContext
                managedObectContext.delete(savedReminder[indexPath.row])
                savedReminder.remove(at: indexPath.row)
                try managedObectContext.save()
            } catch {
                print("Couldn't delete Timer in Core Data, what the fuck just happened!")
            }
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}
