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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        // Remove empty cells from TableView
        tableView.tableFooterView = UIView()
        
        tableView.register(TimerEntryCell.self, forCellReuseIdentifier: "TimerEntryCell")
        
        navigationItem.title = "Timers"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
        let fetchRequest: NSFetchRequest<Timer> = Timer.fetchRequest()
        
        do {
            let savedTimer = try PersistenceService.context.fetch(fetchRequest)
            self.timerList = savedTimer
            self.tableView.reloadData()
        } catch {
            print("Couldnt update the TableView, reload!")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
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
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        //self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.tintColor =     UIColor.orange
        self.navigationController?.navigationBar.barStyle =     UIBarStyle.blackTranslucent
        self.tabBarController?.tabBar.barStyle = UIBarStyle.black
        tableView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = nil
        self.navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.tintColor =     UIColor.white
        self.navigationController?.navigationBar.barStyle =     UIBarStyle.default
        self.tabBarController?.tabBar.barStyle = UIBarStyle.default
        tableView.backgroundColor = .white
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mySwitch = UISwitch()
        //let cell = TimerEntryCell(style: .subtitle, reuseIdentifier: "TimerEntryCell")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TimerEntryCell", for: indexPath) as? TimerEntryCell {
            
            cell.textLabel?.text = timerList[indexPath.row].timerName
            cell.detailTextLabel?.text = timerList[indexPath.row].timerTime.toString(dateFormat: "HH:mm")
            cell.accessoryView = mySwitch
            mySwitch.setOn(true,animated:true)
            return cell
        }
        print("Error")
        return TimerEntryCell()
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

class BackgroundLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        backgroundColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.0)
        textColor = .white
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        backgroundColor = .white
        textColor = .lightGray
    }
}

class TimerEntryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        backgroundColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.0)
        textLabel?.textColor = .orange
        detailTextLabel?.textColor = .orange
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        backgroundColor = .white
        textLabel?.textColor = .black
        detailTextLabel?.textColor = .black
    }
}
