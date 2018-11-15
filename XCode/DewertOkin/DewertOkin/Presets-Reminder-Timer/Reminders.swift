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
    
    public var reminderName : String = ""
    public var reminderDescription : String = ""
    public var reminderTime : Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    /**
     */
    func ´init´(){
    
    }
    
    /**
     */
    override func viewDidLoad () {
        super.viewDidLoad()
    }
    
    @IBAction func addReminder(_ sender: UIStoryboardSegue){
        
    }
    
    @IBAction func addReminderWasCanceled(_ sender: UIStoryboardSegue){
        
    }
    
    func notificationcenter () {
        
    }

}

extension Reminders: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        return cell
    }
}
