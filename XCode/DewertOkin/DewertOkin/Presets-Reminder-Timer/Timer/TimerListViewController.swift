//
//  Timer.swift
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
import CoreBluetooth

class TimerListViewController: UIViewController{
    
    public var timerList = [Timer]() {
        didSet {
        if timerList.isEmpty {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No timers set"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        // Remove empty cells from TableView
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Timers"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let fetchRequest: NSFetchRequest<Timer> = Timer.fetchRequest()
        
        do {
            let savedTimer = try PersistenceService.context.fetch(fetchRequest)
            self.timerList = savedTimer
            self.tableView.reloadData()
        } catch {
            print("Couldnt update the TableView, reload!")
        }
    }

    @IBAction func addTimer(_ sender: UIStoryboardSegue){
        print("Done button was clicked")
        self.tableView.reloadData()
    }
    
    @IBAction func addTimerWasCanceled(_ sender: UIStoryboardSegue){
        print("Cancel button was clicked")
    }
    
    func notificationCenter(){
        // Set the current notification center
    }
    
    var selectedTimer: (Timer, IndexPath)?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "TimerDetail") {
            if let vc = segue.destination as? AddTimerViewController {
                vc.timerToEdit = selectedTimer
            }
        }
    }
}

extension TimerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTimer = (self.timerList[indexPath.row], indexPath)
        performSegue(withIdentifier: "TimerDetail", sender: self)
        selectedTimer = nil
    }
}

extension TimerListViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        var numOfSections: Int = 0
//        if !timerList.isEmpty
//        {
//            tableView.separatorStyle = .singleLine
//            numOfSections            = 1
//            tableView.backgroundView = nil
//        }
//        else
//        {
//            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
//            noDataLabel.text          = "No timers set"
//            noDataLabel.textColor     = UIColor.lightGray
//            noDataLabel.textAlignment = .center
//            tableView.backgroundView  = noDataLabel
//            tableView.separatorStyle  = .none
//        }
//        return numOfSections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mySwitch = UISwitch()
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = timerList[indexPath.row].timerName
        cell.detailTextLabel?.text = timerList[indexPath.row].timerTime.toString(dateFormat: "HH:mm")
        cell.accessoryView = mySwitch
        mySwitch.setOn(true,animated:true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.timerList.remove(at: indexPath.row)
            let fetchRequest: NSFetchRequest<Timer> = Timer.fetchRequest()
            
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
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
