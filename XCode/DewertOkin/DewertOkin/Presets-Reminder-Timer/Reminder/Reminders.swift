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
        
        //-----Achievement "On Top of Things"-related-----
        AchievementModel.updateRemindersSet()
    }
    
    @IBAction func addReminderWasCanceled(_ sender: UIStoryboardSegue){
        print("Cancel button was clicked")
    }
    
    func notificationcenter () {
        
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
}
