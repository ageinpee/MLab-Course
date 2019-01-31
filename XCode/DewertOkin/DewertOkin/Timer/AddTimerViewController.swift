//
//  NewTimerTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 30.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import CoreData

class AddTimerViewController: UITableViewController {
    
    let sections: [TimerSection] = [.enabledSwitch, .details]
    var selectedTimer = DeviceTimer()
    var isEditingPreviouslyCreatedTimer = false
    
    var datePickerVisible = false
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    convenience init(deviceTimer: DeviceTimer?) {
        self.init(style: .grouped)
        
        if let timer = deviceTimer {
            isEditingPreviouslyCreatedTimer = true
            selectedTimer = timer
        } else {
            selectedTimer = DeviceTimer(context: PersistenceService.context)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        self.navigationItem.title = isEditingPreviouslyCreatedTimer ? "Edit Timer" : "Add Timer"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        
        self.tableView.keyboardDismissMode = .onDrag
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            if datePickerVisible {
                return 4
            } else {
                return 3
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
       
            nameTextField.text = selectedTimer.timerName ?? "New Timer"
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
                    cell.detailTextLabel?.text = selectedTimer.timerTime?.toString(dateFormat: "HH:mm") ?? Date().toString(dateFormat: "HH:mm")
                    return cell
                case 1:
                    datePicker.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: 200)
                    datePicker.date = selectedTimer.timerTime ?? Date()
                    cell.addSubview(datePicker)
                    
                    datePicker.translatesAutoresizingMaskIntoConstraints = false
                    
                    cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : datePicker]))
                    cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .alignAllCenterX, metrics: nil, views: ["v0" : datePicker]))
                    return cell
                case 2:
                    cell.textLabel?.text = "Repeat"
                    cell.detailTextLabel?.text = selectedTimer.repeatInterval ?? "Not set"
                    return cell
                case 3:
                    cell.textLabel?.text = "Preset"
                    cell.detailTextLabel?.text = "None Selected"
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
                    cell.detailTextLabel?.text = selectedTimer.timerTime?.toString(dateFormat: "HH:mm") ?? Date().toString(dateFormat: "HH:mm")
                case 1:
                    cell.textLabel?.text = "Repeat"
                    cell.detailTextLabel?.text = selectedTimer.repeatInterval ?? "Not set"
                case 2:
                    cell.textLabel?.text = "Preset"
                    cell.detailTextLabel?.text = "None Selected"
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
                    self.selectedTimer.repeatInterval = RepeatingOptions.never.rawValue
                })
                let daily = UIAlertAction(title: "Daily", style: .default, handler: {action in                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Daily"
                    self.selectedTimer.repeatInterval = RepeatingOptions.daily.rawValue
                })
                let weekly = UIAlertAction(title: "Weekly", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Weekly"
                    self.selectedTimer.repeatInterval = RepeatingOptions.weekly.rawValue
                })
                let weekends = UIAlertAction(title: "Weekends", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Weekends"
                    self.selectedTimer.repeatInterval = RepeatingOptions.weekends.rawValue
                })
                let weekdays = UIAlertAction(title: "Weekdays", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Weekdays"
                    self.selectedTimer.repeatInterval = RepeatingOptions.weekdays.rawValue
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(never)
                alert.addAction(daily)
                alert.addAction(weekly)
                alert.addAction(weekdays)
                alert.addAction(weekends)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                
            case 2:
                print("set preset")
                let alert = UIAlertController(title: "Preset", message: "Select a preset to execute at the specidied time", preferredStyle: .actionSheet)
                
                var presetOptions: [UIAlertAction] = []
                
                for element in globalDeviceObject.availableMemories {
                    let newAction = UIAlertAction(title: element.rawValue, style: .default, handler: {action in
                        tableView.cellForRow(at: IndexPath(item: 2, section: 1))?.detailTextLabel?.text = element.rawValue
                    })
                    presetOptions.append(newAction)
                }
                
                for action in presetOptions {
                    alert.addAction(action)
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                
                if presetOptions.isEmpty {
                    tableView.cellForRow(at: IndexPath(item: 2, section: 1))?.detailTextLabel?.text = "Not available for this device"
                } else {
                    self.present(alert, animated: true, completion: nil)
                }
            default:
                break
            }
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc
    private func datePickerChangedValue(sender: UIDatePicker) {
        tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.detailTextLabel?.text = sender.date.toString(dateFormat: "HH:mm")
        print(sender.date)
        
    }
    
    @objc
    private func doneButtonPressed() {
        guard globalDeviceObject.uuid != "nil" else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        selectedTimer.timerName = nameTextField.text
        selectedTimer.timerTime = datePicker.date
        selectedTimer.deviceUUID = UUID(uuidString: globalDeviceObject.uuid)!
        
        PersistenceService.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func cancelButtonPressed() {
        // Delete the newly created DeviceTimer object, if the user pressed the Add-Button and then cancel
        if !isEditingPreviouslyCreatedTimer {
            PersistenceService.context.delete(selectedTimer)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func selectPreset() {
        //shall open presets menu/page/sheet to select a preset
        let alert = UIAlertController(title: "Choose Preset", message: "", preferredStyle: .actionSheet)
        let preset1 = UIAlertAction(title: "Sleeping", style: .default, handler: {action in
            
        })
        let preset2 = UIAlertAction(title: "Reading", style: .default, handler: {action in
           
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
          
        })
        alert.addAction(preset1)
        alert.addAction(preset2)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        print("Presets Button pressed")
        
    }
}

enum TimerSection {
    case enabledSwitch
    case details
}

enum RepeatingOptions: String {
    case notSet = "Not Set"
    case never = "Never"
    case daily = "Daily"
    case weekly = "Weekly"
    case weekdays = "Weekdays"
    case weekends = "Weekends"
}
