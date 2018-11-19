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

class Timers: UIViewController{
    
    public var timerTime = [String]()
    public var timerName = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
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
        return timerName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mySwitch = UISwitch()
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = timerName[indexPath.row]
        cell.detailTextLabel?.text = timerTime[indexPath.row]
        cell.accessoryView = mySwitch
        mySwitch.setOn(true,animated:true)
        return cell
    }
}
