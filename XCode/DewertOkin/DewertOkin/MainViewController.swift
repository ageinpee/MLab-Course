//
//  MainViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 03.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import Intents

class MainViewController: UITabBarController {
    
    var useNewRemoteStyle = true {
        didSet {
            setupViews()
        }
    }
    
    var remoteVC = UIViewController()
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
            let settings = UIStoryboard(name: "SettingsMore", bundle: nil).instantiateInitialViewController(),
            let explore = UIStoryboard(name: "Explore", bundle: nil).instantiateInitialViewController() else { return }
        
        self.remoteVC = useNewRemoteStyle ? remoteNew : remoteOld
        self.remoteVC.tabBarItem = UITabBarItem(title: "Remote", image: UIImage(named: "remote_icon"), tag: 0)
        
        self.healthVC = UINavigationController(rootViewController: CompanionTableViewController())
        self.healthVC.tabBarItem = UITabBarItem(title: "Companion", image: UIImage(named: "companion"), selectedImage: UIImage(named: "companion_blue"))
        
        self.exploreVC = explore
        self.exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "explore_icon"), selectedImage: UIImage(named: "explore_icon_blue"))
        
        self.settingsVC = settings
        self.settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings_icon"), selectedImage: UIImage(named: "settings_icon_highlighted"))
        
        let controllers = [remoteVC, healthVC, exploreVC ,settingsVC]
        
        self.setViewControllers(controllers, animated: false)
    }
}
