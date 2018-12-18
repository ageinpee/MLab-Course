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

class Reminders: UIViewController, Themeable {
    
    var reminder = [Reminder]() {
        didSet {
            if reminder.isEmpty {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No reminders set"
                noDataLabel.textColor     = UIColor.lightGray
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                tableView.isScrollEnabled = false
            } else {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
                tableView.isScrollEnabled = true
            }
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        Themes.setupTheming(for: self)
        
        tableView.register(ReminderEntryCell.self, forCellReuseIdentifier: "ReminderEntryCell")
        
        navigationItem.title = "Reminder"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            let reminder = try PersistenceService.context.fetch(fetchRequest)
            self.reminder = reminder
            self.tableView.reloadData()
        } catch {
            print("Couldnt update the TableView, reload!")
        }
    }
    
    func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
    
    func setDarkTheme() {
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        //self.tabBarController?.tabBar.barStyle = UIBarStyle.black
        tableView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    func setDefaultTheme() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = nil
        self.navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        //self.tabBarController?.tabBar.barStyle = UIBarStyle.default
        tableView.backgroundColor = .white
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderEntryCell", for: indexPath) as? ReminderEntryCell {
            let mySwitch = UISwitch()
            
            cell.textLabel?.text = reminder[indexPath.row].reminderName
            cell.detailTextLabel?.text = (reminder[indexPath.row].reminderTime?.toString(dateFormat: "HH:mm"))! + " | " +  reminder[indexPath.row].reminderDescription!
            cell.accessoryView = mySwitch
            mySwitch.setOn(true,animated:true)
            return cell
        }
        return ReminderEntryCell()
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

class ReminderEntryCell: UITableViewCell, Themeable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        Themes.setupTheming(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    func setDarkTheme() {
        backgroundColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.0)
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .white
    }
    
    func setDefaultTheme() {
        backgroundColor = .white
        textLabel?.textColor = .black
        detailTextLabel?.textColor = .black
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
}
