//
//  MainViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 03.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remoteVC = UIStoryboard(name: "Remote", bundle: nil).instantiateInitialViewController()!
        remoteVC.tabBarItem = UITabBarItem(title: "Remote", image: UIImage(named: "remote_icon"), tag: 0)

        let reminderVC = UIStoryboard(name: "Reminder", bundle: nil).instantiateInitialViewController()!
        reminderVC.tabBarItem = UITabBarItem(title: "Reminder", image: UIImage(named: "reminder_icon"), tag: 1)
        
        let settingsVC = UIStoryboard(name: "SettingsMore", bundle: nil).instantiateInitialViewController()!
        settingsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        let controllers = [remoteVC, reminderVC, settingsVC]
        
        viewControllers = controllers
        
    }
}
