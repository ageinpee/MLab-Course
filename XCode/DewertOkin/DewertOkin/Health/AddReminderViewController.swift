//
//  AddReminderViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 11.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class NewReminderTableViewController: UITableViewController {
    
    let sections: [TimerSection] = [.enabledSwitch, .details]
    var selectedReminder = Reminder()
    var isEditingPreviouslyCreatedReminder = false
    
    var datePickerVisible = false
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    convenience init(reminder: Reminder?) {
        self.init(style: .grouped)
        
        if let selReminder = reminder {
            isEditingPreviouslyCreatedReminder = true
            selectedReminder = selReminder
        } else {
            selectedReminder = Reminder(context: PersistenceService.context)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        self.navigationItem.title = isEditingPreviouslyCreatedReminder ? "Edit Reminder" : "Add Reminder"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        
        self.tableView.keyboardDismissMode = .onDrag
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            if datePickerVisible {
                return 3
            } else {
                return 2
            }
        default:
            return 0
        }
    }
    
    private let nameTextField = UITextField()
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.setDate(Date(), animated: true)
        datePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)), for: .valueChanged)
        return datePicker
    }()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            
            nameTextField.text = selectedReminder.reminderName ?? "New Reminder"
            nameTextField.clearButtonMode = .always
            cell.addSubview(nameTextField)
            
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : nameTextField]))
            cell.addConstraint(NSLayoutConstraint(item: nameTextField, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
            return cell
        case 1:
            
            if datePickerVisible {
                var cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "defaultCell")
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Time"
                    cell.detailTextLabel?.text = selectedReminder.reminderTime?.toString(dateFormat: "HH:mm") ?? Date().toString(dateFormat: "HH:mm")
                    return cell
                case 1:
                    datePicker.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: 200)
                    datePicker.date = selectedReminder.reminderTime ?? Date()
                    cell.addSubview(datePicker)
                    
                    datePicker.translatesAutoresizingMaskIntoConstraints = false
                    
                    cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : datePicker]))
                    cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .alignAllCenterX, metrics: nil, views: ["v0" : datePicker]))
                    return cell
                case 2:
                    cell.textLabel?.text = "Repeat"
                    cell.detailTextLabel?.text = selectedReminder.reminderRepeatInterval ?? "Not set"
                    return cell
                default:
                    return UITableViewCell()
                }
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "defaultCell")
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Time"
                    cell.detailTextLabel?.text = selectedReminder.reminderTime?.toString(dateFormat: "HH:mm") ?? Date().toString(dateFormat: "HH:mm")
                case 1:
                    cell.textLabel?.text = "Repeat"
                    cell.detailTextLabel?.text = selectedReminder.reminderRepeatInterval ?? "Not set"
                default:
                    return UITableViewCell()
                }
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Name"
        case 1: return "Details"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: break
        case 1:
            switch indexPath.row {
            case 0:
                tableView.beginUpdates()
                if datePickerVisible {
                    datePickerVisible = false
                    tableView.deleteRows(at: [IndexPath(item: 1, section: 1)], with: .fade)
                } else {
                    datePickerVisible = true
                    tableView.insertRows(at: [IndexPath(item: 1, section: 1)], with: .fade)
                }
                tableView.endUpdates()
                print("settime")
            case 1:
                print("set repeat")
                let alert = UIAlertController(title: "Repeat", message: "How often shall this timer be repeated?", preferredStyle: .actionSheet)
                let never = UIAlertAction(title: "Never", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Never"
                    self.selectedReminder.reminderRepeatInterval = RepeatingOptions.never.rawValue
                })
                let daily = UIAlertAction(title: "Daily", style: .default, handler: {action in                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Daily"
                    self.selectedReminder.reminderRepeatInterval = RepeatingOptions.daily.rawValue
                })
                let weekly = UIAlertAction(title: "Weekly", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Weekly"
                    self.selectedReminder.reminderRepeatInterval = RepeatingOptions.weekly.rawValue
                })
                let weekends = UIAlertAction(title: "Weekends", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Weekends"
                    self.selectedReminder.reminderRepeatInterval = RepeatingOptions.weekends.rawValue
                })
                let weekdays = UIAlertAction(title: "Weekdays", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Weekdays"
                    self.selectedReminder.reminderRepeatInterval = RepeatingOptions.weekdays.rawValue
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(never)
                alert.addAction(daily)
                alert.addAction(weekly)
                alert.addAction(weekdays)
                alert.addAction(weekends)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            default:
                break
            }
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc
    private func enabledSwitchChanged(sender: UISwitch) {
        
    }
    
    @objc
    private func datePickerChangedValue(sender: UIDatePicker) {
        tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.detailTextLabel?.text = sender.date.toString(dateFormat: "HH:mm")
        print(sender.date)
        
    }
    
    @objc
    private func doneButtonPressed() {
        selectedReminder.reminderName = nameTextField.text
        selectedReminder.reminderTime = datePicker.date
        selectedReminder.deviceUUID = UUID(uuidString: globalDeviceObject.uuid)!
        
        PersistenceService.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func cancelButtonPressed() {
        // Delete the newly created DeviceTimer object, if the user pressed the Add-Button and then cancel
        if !isEditingPreviouslyCreatedReminder {
            PersistenceService.context.delete(selectedReminder)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

