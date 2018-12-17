//
//  SettingTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 06.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import AVFoundation

class SettingTableViewController: UITableViewController {
    
    private let settingsEntries: [SettingsEntry] = [.deviceInfo, .achievements, .presets, .useOldRemote,
                        .nearestVendor, .accessories, .about, .darkMode]
    
    private let search = UISearchController(searchResultsController: nil)
    
    
    //-----Achievement "Button Maniac"-related-----
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBAction func barButtonClicked(_ sender: UIBarButtonItem) {
        AchievementModel.updateButtonClickCount()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SettingsEntryCell.self, forCellReuseIdentifier: "SettingCell")
        
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        //self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.tintColor =     UIColor.orange
        self.navigationController?.navigationBar.barStyle =     UIBarStyle.blackTranslucent
        self.tabBarController?.tabBar.barStyle = UIBarStyle.black
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = nil
        self.navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.tintColor =     UIColor.white
        self.navigationController?.navigationBar.barStyle =     UIBarStyle.default
        self.tabBarController?.tabBar.barStyle = UIBarStyle.default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Sets the title of the surrounding Navigation Controller
        navigationItem.title = "More"
        //navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        self.barButtonItem.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsEntries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = settingsEntries[indexPath.row].rawValue
        
        if (indexPath.row == settingsEntries.firstIndex(of: .darkMode)) {
            cell.accessoryView = {
                let darkModeSwitch = UISwitch()
                darkModeSwitch.isOn = false
                darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchChanged(sender:)), for: .valueChanged)
                return darkModeSwitch
            }()
        }
        
        if (indexPath.row == settingsEntries.firstIndex(of: .accessibilityMode)) {
            cell.accessoryView = {
                let accessibilityModeSwitch = UISwitch()
                accessibilityModeSwitch.isOn = false
                accessibilityModeSwitch.addTarget(self, action: #selector(accessibilityModeSwitchChanged(sender:)), for: .valueChanged)
                return accessibilityModeSwitch
            }()
        }
        
        if (indexPath.row == settingsEntries.firstIndex(of: .nearestVendor)) {
            cell.accessoryType = .disclosureIndicator
        }
        
        if (indexPath.row == settingsEntries.firstIndex(of: .useOldRemote)) {
            cell.accessoryView = {
                let oldRemoteSwitch = UISwitch()
                oldRemoteSwitch.isOn = false
                oldRemoteSwitch.addTarget(self, action: #selector(oldRemoteSwitchChanged(sender:)), for: .valueChanged)
                return oldRemoteSwitch
            }()
        }
        
        if (indexPath.row == settingsEntries.firstIndex(of: .deviceInfo)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .presets)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .achievements)) {
            cell.accessoryType = .disclosureIndicator
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(resetAchievements))
            longPress.minimumPressDuration = 2
            cell.addGestureRecognizer(longPress)
        } else if (indexPath.row == settingsEntries.firstIndex(of: .warranty)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .about)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .siri)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .accessories)) {
            cell.accessoryType = .disclosureIndicator
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == settingsEntries.firstIndex(of: .accessories)) {
            pushAccessoriesStoryboard()
        } else if (indexPath.row == settingsEntries.firstIndex(of: .achievements)) {
            pushAchievementsStoryboard()
        } else if (indexPath.row == settingsEntries.firstIndex(of: .nearestVendor)) {
            pushVendorStoryboard()
        }
    }
    
    @objc
    private func pushVendorStoryboard() {
        if let vc = UIStoryboard(name: "NearestVendor", bundle: nil).instantiateInitialViewController() as? NearestVendorViewController {
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc
    private func resetAchievements() {
        AchievementModel.resetAchievements()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    @objc
    private func darkModeSwitchChanged(sender: UISwitch!) {
        if(!sender.isOn) {
            AchievementModel.lightAchievementUnlocked()
        }
        print("Dark Mode switch is on: \(sender.isOn)")
        
        if sender.isOn == true {
            UserDefaults.standard.set(true, forKey: "darkModeEnabled")
            
            // Post the notification to let all current view controllers that the app has changed to dark mode, and they should theme themselves to reflect this change.
            NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
            
        } else {
            
            UserDefaults.standard.set(false, forKey: "darkModeEnabled")
            
            // Post the notification to let all current view controllers that the app has changed to non-dark mode, and they should theme themselves to reflect this change.
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
    }
    
    @objc
    private func accessibilityModeSwitchChanged(sender: UISwitch!) {
        print("Accessibility Mode switch is on: \(sender.isOn)")
    }
    
    @objc
    private func oldRemoteSwitchChanged(sender: UISwitch!) {
        if (sender.isOn) {
            //RemoteController.useOldRemoteLayout = true
            print("Using old Remote Layout")
        } else {
            //RemoteController.useOldRemoteLayout = false
            print("Using fancy Remote Layout")
        }
    }
    
    @objc
    private func pushAccessoriesStoryboard() {
        if let vc = UIStoryboard(name: "AccessoriesStoryboard", bundle: nil).instantiateInitialViewController() as? AccessoriesTableViewController {
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc
    private func pushAchievementsStoryboard() {
        if let vc = UIStoryboard(name: "AchievementsStoryboard", bundle: nil).instantiateInitialViewController() as? AchievementsTableViewController {
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

}

extension SettingTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension Notification.Name {
    static let darkModeEnabled = Notification.Name("com.project.DewertOkinMLab2018.darkModeEnabled")
    static let darkModeDisabled = Notification.Name("com.project.DewertOkinMLab2018.darkModeDisabled")

}

class SettingsEntryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        backgroundColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.0)
        textLabel?.textColor = .orange
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        backgroundColor = .white
        textLabel?.textColor = .black
    }
}
