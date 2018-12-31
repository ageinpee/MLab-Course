//
//  NewTimerListTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 31.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import CoreData

class NewTimerListTableViewController: UITableViewController {
    
    public var timerList = [DeviceTimer]() {
        didSet {
            if timerList.isEmpty {
                let noDataLabel = BackgroundLabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No timers set"
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timerList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mySwitch = UISwitch()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TimerEntryCell", for: indexPath) as? TimerEntryCell {
            
            cell.textLabel?.text = timerList[indexPath.row].timerName
            cell.detailTextLabel?.text = timerList[indexPath.row].timerTime?.toString(dateFormat: "HH:mm")
            cell.accessoryView = mySwitch
            mySwitch.setOn(true,animated:true)
            return cell
        }
        print("Error")
        return TimerEntryCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTimer = timerList[indexPath.row]
        let vc = UINavigationController(rootViewController: NewTimerTableViewController(deviceTimer: selectedTimer)) 
        present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.timerList.remove(at: indexPath.row)
            let fetchRequest: NSFetchRequest<DeviceTimer> = DeviceTimer.fetchRequest()
            
            do {
                var savedTimer = try PersistenceService.context.fetch(fetchRequest)
                let managedObectContext = PersistenceService.persistentContainer.viewContext
                managedObectContext.delete(savedTimer[indexPath.row])
                savedTimer.remove(at: indexPath.row)
                try managedObectContext.save()
            } catch {
                print("Couldn't delete Timer in Core Data, what the fuck just happened!")
            }
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @objc
    private func presentAddTimerController() {
        present(UINavigationController(rootViewController: NewTimerTableViewController(deviceTimer: nil)), animated: true, completion: nil)
    }
    
    private func setupViews() {
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(presentAddTimerController))
        navigationItem.title = "Timer"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(TimerEntryCell.self, forCellReuseIdentifier: "TimerEntryCell")

    }
    
    private func getSavedData() {
        let fetchRequest: NSFetchRequest<DeviceTimer> = DeviceTimer.fetchRequest()
        
        do {
            let savedTimer = try PersistenceService.context.fetch(fetchRequest)
            self.timerList = savedTimer
            self.tableView.reloadData()
        } catch {
            print("Couldn't update the TableView, reload!")
        }
    }

}
