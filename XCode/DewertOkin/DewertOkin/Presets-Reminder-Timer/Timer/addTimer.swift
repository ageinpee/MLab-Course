//
//  addTimer.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 13.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import UserNotifications
import NotificationCenter

class addTimer: UIViewController{
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if !(name.text == ""){
        self.performSegue(withIdentifier: "TimerWasAdded", sender: self)
        } else {
            print("Invalid Name")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let time = timePicker.date
        guard let destination = segue.destination as? Timers else { return }
        let addTime = Timer(context: PersistenceService.context)
        addTime.timerName = name.text!
        addTime.timerTime = time
        PersistenceService.saveContext()
        destination.timer.append(addTime)
    }
    
    func notificationCenter(){
        // Set the current notification center
    }
}
