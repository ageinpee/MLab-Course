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
import BLTNBoard

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
    
    lazy var bulletinManager: BLTNItemManager = {
        let root: BLTNItem = self.getPage()
        let manager = BLTNItemManager(rootItem: root)
        manager.backgroundViewStyle = .dimmed
        return manager
    }()
    
    func getPage() -> BLTNItem {
        let page = BLTNPageItem(title: "Exercise")
        
        switch globalDeviceObject.type {
        case "chair_2Motors":
            page.image = UIImage(named: "Squad-Exercise")?.resize(size: CGSize(width: 200, height: 200))
        case "bed_2Motors":
            page.image = UIImage(named: "Arch-Exercise")?.resize(size: CGSize(width: 200, height: 200))
        case "table":
            page.image = UIImage(named: "Wrist-Exercise")?.resize(size: CGSize(width: 200, height: 200))
        default:
            print("Error setting exercise image: Device Type not found.")
        }
        
        page.descriptionText = "Your companion recommends the following Workout to you:"
        page.actionButtonTitle = "Do Workout"
        page.alternativeButtonTitle = "Maybe Later"
        
        page.actionHandler = { (item: BLTNActionItem) in
            Health.shared.exerciseHistory.append(ExerciseEvent(time: Date(), completed: true))
            page.manager?.dismissBulletin()
            print("Action button tapped")
            // Setup chart data
            Health.shared.updateStatisticsChart()
            AchievementModel.registerNewExercise()
        }
        
        page.alternativeHandler = { (item: BLTNActionItem) in
            print("Maybe later tapped")
            page.manager?.dismissBulletin()
            Health.shared.exerciseHistory.append(ExerciseEvent(time: Date(), completed: false))
            // Setup chart data
            Health.shared.updateStatisticsChart()
        }
        page.requiresCloseButton = false
        return page
    }
    
    func showActivityReminder() {
        guard !bulletinManager.isShowingBulletin else { return }
        bulletinManager.showBulletin(above: self)
    }
    
    func updateBulletinImage() {
        guard !bulletinManager.isShowingBulletin else {
            print("Couldn't update Bulletin Image because Bulletin is currently showing.")
            return
        }
        print("Updating Bulletin Image")
        bulletinManager = {
            let root: BLTNItem = self.getPage()
            let manager = BLTNItemManager(rootItem: root)
            manager.backgroundViewStyle = .dimmed
            return manager
        }()
    }
}
