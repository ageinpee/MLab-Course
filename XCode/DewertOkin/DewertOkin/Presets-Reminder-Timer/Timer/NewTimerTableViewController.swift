//
//  NewTimerTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 30.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit

class NewTimerTableViewController: UITableViewController {
    
    let sections: [TimerSection] = [.enabledSwitch, .details]
    var selectedTimer: DeviceTimer?
    
    var datePickerVisible = false
    
    var selectedTime: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        self.navigationItem.title = "Add Timer"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        
        self.tableView.keyboardDismissMode = .onDrag
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.register(NameTextFieldCell.self, forCellReuseIdentifier: "nameCell")
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: "dateCell")
        
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
                return 4
            } else {
                return 3
            }
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as? NameTextFieldCell {
                return cell
            }
            return UITableViewCell()
//            cell.textLabel?.text = "Placeholder Name"
//            let newSwitch = UISwitch()
//            newSwitch.isOn = true
//            newSwitch.addTarget(self, action: #selector(enabledSwitchChanged(sender:)), for: .valueChanged)
//            cell.accessoryView = newSwitch
        case 1:
            
            if datePickerVisible {
                var normalCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                normalCell = UITableViewCell.init(style: .value1, reuseIdentifier: "defaultCell")
                let dateCell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
                switch indexPath.row {
                case 0:
                    normalCell.textLabel?.text = "Time"
                    normalCell.detailTextLabel?.text = selectedTime.toString(dateFormat: "HH:mm")
                    return normalCell
                case 1:
                    return dateCell
                case 2:
                    normalCell.textLabel?.text = "Repeat"
                    normalCell.detailTextLabel?.text = "Never"
                    return normalCell
                case 3:
                    normalCell.textLabel?.text = "Preset"
                    normalCell.detailTextLabel?.text = "None Selected"
                    return normalCell
                default:
                    return UITableViewCell()
                }
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "defaultCell")
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Time"
                    cell.detailTextLabel?.text = selectedTime.toString(dateFormat: "HH:mm")
                case 1:
                    cell.textLabel?.text = "Repeat"
                    cell.detailTextLabel?.text = "Never"
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
        case 0: return "Timer Name"
        case 1: return "Timer Details"
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
                })
                let daily = UIAlertAction(title: "Daily", style: .default, handler: {action in                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Daily"
                })
                let weekly = UIAlertAction(title: "Weekly", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Weekly"
                })
                let weekends = UIAlertAction(title: "Weekends", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Weekends"
                })
                let weekdays = UIAlertAction(title: "Weekdays", style: .default, handler: {action in
                    tableView.cellForRow(at: IndexPath(item: 1, section: 1))?.detailTextLabel?.text = "Weekdays"
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
    private func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func cancelButtonPressed() {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class NameTextFieldCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    private func setupViews() {
        let textfield = UITextField()
        textfield.text = "This is a test!"
        self.addSubview(textfield)
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : textfield]))
        addConstraint(NSLayoutConstraint(item: textfield, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

class DatePickerCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 200))
        datePicker.datePickerMode = .time
        datePicker.setDate(Date(), animated: true)
        datePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)), for: .valueChanged)
        self.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : datePicker]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .alignAllCenterX, metrics: nil, views: ["v0" : datePicker]))
        //addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    @objc
    private func datePickerChangedValue(sender: UIDatePicker) {
        print(sender.date)
        
    }
}

enum TimerSection {
    case enabledSwitch
    case details
}

enum RepeatingOptions {
    case never
    case daily
    case weekly
    case weekdays
    case weekends
}
