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
    
    var useNewRemoteStyle = true {
        didSet {
            setupViews()
        }
    }
    
    var remoteVC = UIViewController()
    var reminderVC = UIViewController()
    var settingsVC = UIViewController()
    var healthVC = UIViewController()
    var exploreVC = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        guard let remoteNew = UIStoryboard(name: "SecondRemote", bundle: nil).instantiateInitialViewController(),
            let remoteOld = UIStoryboard(name: "OldRemote", bundle: nil).instantiateInitialViewController(),
            let reminder = UIStoryboard(name: "Reminder", bundle: nil).instantiateInitialViewController(),
            let settings = UIStoryboard(name: "SettingsMore", bundle: nil).instantiateInitialViewController(),
            let explore = UIStoryboard(name: "Explore", bundle: nil).instantiateInitialViewController() else { return }
        
        remoteVC = useNewRemoteStyle ? remoteNew : remoteOld
        remoteVC.tabBarItem = UITabBarItem(title: "Remote", image: UIImage(named: "remote_icon"), tag: 0)
        
        reminderVC = reminder
        reminderVC.tabBarItem = UITabBarItem(title: "Reminder", image: UIImage(named: "reminder_icon"), tag: 1)
        
        healthVC = UINavigationController(rootViewController: CompanionTableViewController())
        healthVC.tabBarItem = UITabBarItem(title: "Companion", image: UIImage(named: "companion"), selectedImage: UIImage(named: "companion_blue"))
        
        exploreVC = explore
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "explore_icon"), selectedImage: UIImage(named: "explore_icon_blue"))
        
        settingsVC = settings
        settingsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        
        let controllers = [remoteVC, healthVC, exploreVC ,settingsVC]
        
        setViewControllers(controllers, animated: false)
    }
}
