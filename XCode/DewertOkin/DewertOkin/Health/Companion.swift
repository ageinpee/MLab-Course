//
//  HealthTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 10.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import Charts
import CoreData
import UserNotifications
import BLTNBoard

class CompanionTableViewController: UITableViewController, TimeIntervalSelectionDelegate {
    

    let defaultCell = "defaultCell"
    let statisticsCell = "statisticsCell"
    let reminderCell = "reminderCell"
    
    let tableViewSections = ["Statistics", "Main Reminder", "Other Reminders", "Achievements"]

    public var reminderList = [Reminder]()
    
    let barChartView: BarChartView = {
        let view = BarChartView()
        view.drawValueAboveBarEnabled = true
        view.rightAxis.enabled = false
        
        view.leftAxis.axisMinimum = 0
        view.leftAxis.drawZeroLineEnabled = true
        view.leftAxis.drawGridLinesEnabled = false
        view.leftAxis.granularity = 1
        view.leftAxis.drawAxisLineEnabled = false
    
        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.labelPosition = .bottom
        view.xAxis.granularity = 1
        view.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Thu", "Fri", "Sat", "Sun", "Mon", "Tue", "Wed"])
        
        view.legend.enabled = true
    
        view.setScaleEnabled(false)
        view.noDataText = "No exercise data available."
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height), style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCell)
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: statisticsCell)
        tableView.register(ReminderCell.self, forCellReuseIdentifier: reminderCell)
        
        self.navigationItem.title = "Companion"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.estimatedRowHeight = 100
        
        getSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scheduleNormalReminderNotifications()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: statisticsCell, for: indexPath) as? StatisticsCell {
                cell.barChart = barChartView
                return cell
            }
            return StatisticsCell()
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: reminderCell, for: indexPath)
            cell.textLabel?.text = "Activity Reminder"
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body).withSize(22)
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = "Enable reminders to stand up every \(Int(Health.shared.activityReminderTimeIntervalInMinutes)) min."
            cell.detailTextLabel?.numberOfLines = 0
            cell.accessoryView = {
                let activitySwitch = UISwitch()
                activitySwitch.isOn = Health.shared.activityReminderEnabled
                activitySwitch.onTintColor = .red
                activitySwitch.addTarget(self, action: #selector(activityReminderValueChanged(sender:)), for: .valueChanged)
                return activitySwitch
            }()
            return cell
        case 2:
            switch indexPath.row {
                // Make the last row show the Add Reminder Button
            case reminderList.count:
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultCell, for: indexPath)
                cell.textLabel?.text = "Add Reminder..."
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: reminderCell, for: indexPath)
                cell.textLabel?.text = reminderList[indexPath.row].reminderName
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                cell.detailTextLabel?.text = "\(reminderList[indexPath.row].reminderTime?.toString(dateFormat: "HH:mm") ?? "Error fetching time") | \(reminderList[indexPath.row].reminderRepeatInterval ?? "Error fetching repeat interval")"
                //cell.accessoryType = .disclosureIndicator
                cell.accessoryView = UISwitch()
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCell, for: indexPath)
            cell.textLabel?.text = "Achievements"
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return reminderList.count + 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSections.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            let vc = TimeIntervalSelectionTableViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            switch indexPath.row {
            case reminderList.count:
                present(UINavigationController(rootViewController: NewReminderTableViewController(reminder: nil)), animated: true, completion: nil)
            default:
                present(UINavigationController(rootViewController: NewReminderTableViewController(reminder: reminderList[indexPath.row])), animated: true, completion: nil)
            }
        case 3:
            showAchievements()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ReminderSection.exerciseStatistics.rawValue
        case 1:
            return ReminderSection.activityReminder.rawValue
        case 2:
            return ReminderSection.regularReminders.rawValue
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    @objc
    private func activityReminderValueChanged(sender: UISwitch) {
        if sender.isOn {
            Health.shared.activityReminderEnabled = true
        } else {
            Health.shared.activityReminderEnabled = false
        }
    }
    
    private func getSavedData() {
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        let predicateUUID = NSPredicate(format: "deviceUUID = %@", globalDeviceObject.uuid)
        fetchRequest.predicate = predicateUUID
        
        do {
            let savedReminders = try PersistenceService.context.fetch(fetchRequest)
            self.reminderList = savedReminders
            self.tableView.reloadData()
        } catch {
            print("Couldn't update the TableView, reload!")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case reminderList.count:
                return false
            default:
                return true
            }
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            if editingStyle == .delete {
                self.reminderList.remove(at: indexPath.row)
                let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
                
                do {
                    var savedReminder = try PersistenceService.context.fetch(fetchRequest)
                    let managedObectContext = PersistenceService.persistentContainer.viewContext
                    managedObectContext.delete(savedReminder[indexPath.row])
                    savedReminder.remove(at: indexPath.row)
                    try managedObectContext.save()
                } catch {
                    print("Couldn't delete Reminder in Core Data, what the fuck just happened!")
                }
                
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.endUpdates()
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
    }
    
    @objc
    private func showAchievements() {
        if let navigator = navigationController {
            navigator.pushViewController(AchievementsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
        }
    }
    
    func updateChartData() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StatisticsCell {
            cell.setupChartData()
        }
    }
    
    private func addActivityReminderNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Your Activity Reminder"
        content.body = "It's time to get up!"
        content.sound = UNNotificationSound.default
        
        let timerFinishesTime = Date().addingTimeInterval(0)
        var dateComponent = DateComponents()
        dateComponent.hour = Calendar(identifier: .gregorian).component(.hour, from: timerFinishesTime)
        dateComponent.minute = Calendar(identifier: .gregorian).component(.minute, from: timerFinishesTime)
        dateComponent.second = Calendar(identifier: .gregorian).component(.second, from: timerFinishesTime)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let identifier = "activityReminderBackground"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    
    private func scheduleNormalReminderNotifications() {
        let center = UNUserNotificationCenter.current()
        for reminder in reminderList {
            center.removePendingNotificationRequests(withIdentifiers: [reminder.reminderName ?? ""])
            let content = UNMutableNotificationContent()
            if let reminderName = reminder.reminderName, let reminderTime = reminder.reminderTime, let repeats = reminder.reminderRepeatInterval {
                content.title = NSString.localizedUserNotificationString(forKey: reminderName, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "Press to view other Reminders.", arguments: nil)
                
                // Configure the trigger for a 7am wakeup.
                var dateInfo = DateComponents()
                dateInfo.hour = Calendar.current.component(.hour, from: reminderTime)
                dateInfo.minute = Calendar.current.component(.minute, from: reminderTime)
                var trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                if repeats != RepeatingOptions.never.rawValue && repeats != RepeatingOptions.notSet.rawValue {
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
                }
                
                
                // Create the request object.
                let request = UNNotificationRequest(identifier: reminderName, content: content, trigger: trigger)
                
                // Schedule the request.
                center.add(request) { (error : Error?) in
                    if let theError = error {
                        print(theError.localizedDescription)
                    }
                }
                print("Scheduled Notification for reminder \(reminderName) at \(reminderTime) which repeats: \(trigger.repeats)")
            }
            
        }
    }
    
    func selectedTimeInterval(minutes: Float) {
        Health.shared.activityReminderTimeIntervalInMinutes = minutes
        Health.shared.activityTimer?.invalidate()
        Health.shared.startActivityTracking()
    }
}
