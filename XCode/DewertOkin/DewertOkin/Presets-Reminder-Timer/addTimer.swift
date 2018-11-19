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
    
    public var timerTime = [Int]()
    public var timerName = [String]()
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // This needs a better handler, since you can always type it in
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let time = timePicker.date
        let components = Calendar.current.dateComponents([.hour,.minute],from: time)
        let hour = components.hour!
        let minute = components.minute!
        if let destination = segue.destination as? Timers {
            destination.timerTime.append((String(hour) + ":" + String(minute)))
            destination.timerName.append(name.text!)
        }
        
    }
    
    func notificationCenter(){
        // Set the current notification center
    }
}
