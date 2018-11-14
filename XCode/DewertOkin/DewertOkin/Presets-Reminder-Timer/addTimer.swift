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
    public var timerDescription = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneTimer(){
        print("Timer added successfully")
    }
    
    @IBAction func cancelNewTimer(segue: UIStoryboardSegue){
        print("Unwinding to Timers Storyboard")
    }
    
    func notificationCenter(){
        // Set the current notification center
    }
}
