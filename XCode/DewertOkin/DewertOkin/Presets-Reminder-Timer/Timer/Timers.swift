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

class Timers: UIViewController{
    
    public var timer = [Timer]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Timer> = Timer.fetchRequest()
        
        do {
            let timer = try PersistenceService.context.fetch(fetchRequest)
            self.timer = timer
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
}

extension Timers: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mySwitch = UISwitch()
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = timer[indexPath.row].timerName
        cell.detailTextLabel?.text = timer[indexPath.row].timerTime.toString(dateFormat: "HH:MM")
        cell.accessoryView = mySwitch
        mySwitch.setOn(true,animated:true)
        return cell
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
