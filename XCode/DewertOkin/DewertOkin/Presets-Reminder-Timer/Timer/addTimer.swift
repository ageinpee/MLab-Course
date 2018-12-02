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
    private var saved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if !(name.text == ""){
            saved = true
            self.performSegue(withIdentifier: "TimerWasAdded", sender: self)
        } else {
            print("Invalid Name")
            // Animation
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? Timers else { return }
        if(saved){
            let time = timePicker.date
            let addTime = Timer(context: PersistenceService.context)
            addTime.timerName = name.text!
            addTime.timerTime = time
            PersistenceService.saveContext()
            destination.timer.append(addTime)
        }
        saved = false
    }
}
