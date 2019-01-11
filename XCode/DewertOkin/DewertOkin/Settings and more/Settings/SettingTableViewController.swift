//
//  SettingTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 06.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import AVFoundation

enum SettingsEntry: String {
    case deviceInfo = "Device Info"
    case presets = "Manage Presets"
    case achievements = "Achievements"
    case accessibilityMode = "Accessibility Mode"
    case warranty = "Warranty"
    case siri = "Siri"
    case about = "About [Company]"
    case darkMode = "Dark Mode"
    case accessories = "Accessories"
    case useOldRemote = "Use Old Remote Layout"
    case nearestVendor = "Nearest Vendor"
    case manageDevices = "Manage Devices"
    case health = "Health Settings"
    case test = "Test"
    case alarm = "Alarm"
    case rfpairing = "RF Pairing Test"
    case bluetoothPairing = "Bluetooth Pairing Test"
}

class SettingTableViewController: UITableViewController, Themeable {
    
    private let settingsEntries: [[SettingsEntry]] = [
        [.manageDevices, .deviceInfo, .nearestVendor],
        [.presets, .alarm, .health, .useOldRemote, .darkMode],
        [.achievements,.accessories, .test, .rfpairing, .bluetoothPairing]
    ]
    private let settingsSections = ["Devices and Support", "Preferences", "Other"]
    
    
    //-----Achievement "Button Maniac"-related-----
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBAction func barButtonClicked(_ sender: UIBarButtonItem) {
        AchievementModel.updateButtonClickCount()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SettingsEntryCell.self, forCellReuseIdentifier: "SettingCell")
        
        Themes.setupTheming(for: self)
    }
    
    func setDarkTheme() {
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.tabBarController?.tabBar.barStyle = UIBarStyle.black
        //self.navigationController?.tabBarController?.tabBar.unselectedItemTintColor = .white
    }
    
    func setDefaultTheme() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = nil
        self.navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.tabBarController?.tabBar.barStyle = UIBarStyle.default
        //self.navigationController?.tabBarController?.tabBar.unselectedItemTintColor = nil

    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "More"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.barButtonItem.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsEntries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsEntries[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsSections[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        
        cell.textLabel?.text = settingsEntries[indexPath.section][indexPath.row].rawValue
        
        if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .darkMode)) {
            cell.accessoryView = {
                let darkModeSwitch = UISwitch()
                darkModeSwitch.onTintColor = .orange
                if let darkModeSwitchIsOn = UserDefaults.standard.object(forKey: "darkModeEnabled") as? Bool {
                        darkModeSwitch.isOn = darkModeSwitchIsOn
                }
                darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchChanged(sender:)), for: .valueChanged)
                return darkModeSwitch
            }()
        }
        
        if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .nearestVendor)) {
            cell.accessoryType = .disclosureIndicator
        }
        
        if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .useOldRemote)) {
            cell.accessoryView = {
                let oldRemoteSwitch = UISwitch()
                oldRemoteSwitch.isOn = false
                if let oldRemoteSwitchIsOn = UserDefaults.standard.object(forKey: "oldRemoteActivated") as? Bool {
                    oldRemoteSwitch.isOn = oldRemoteSwitchIsOn
                }
                oldRemoteSwitch.addTarget(self, action: #selector(oldRemoteSwitchChanged(sender:)), for: .valueChanged)
                return oldRemoteSwitch
            }()
        }
        
        if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .deviceInfo)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .presets)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .achievements)) {
            cell.accessoryType = .disclosureIndicator
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(resetAchievements))
            longPress.minimumPressDuration = 2
            cell.addGestureRecognizer(longPress)
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .warranty)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .about)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .siri)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .accessories)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .manageDevices)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .health)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .test)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .alarm)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .rfpairing)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .bluetoothPairing)) {
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .achievements)) {
            pushAchievementsStoryboard()
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .manageDevices)) {
            pushDevicesStoryboard()
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .health)) {
            pushHealthController()
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .test)) {
            pushTestController()
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .presets)) {
            pushPresetsController()
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .alarm)) {
            pushAlarmViewController()
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .rfpairing)) {
            pushRFPairingController()
        } else if (indexPath.row == settingsEntries[indexPath.section].firstIndex(of: .bluetoothPairing)) {
            pushBluetoothPairing()
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func pushBluetoothPairing() {
        if let vc = UIStoryboard(name: "BluetoothPairing", bundle: nil).instantiateInitialViewController() {
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func pushRFPairingController() {
        if let vc = UIStoryboard(name: "RFPairing", bundle: nil).instantiateInitialViewController() {
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func pushTestController() {
        // Present the views you are testing here
    }
    
    @objc
    private func pushAlarmViewController() {
        present(AlarmCreationViewController(), animated: true, completion: nil)
    }
    
    @objc
    private func pushPresetsController() {
        if let navigator = navigationController {
            navigator.pushViewController(SelectPresetViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
        }
    }
    
    private func pushHealthController() {
        if let navigator = navigationController {
            navigator.pushViewController(HealthViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
        }
    }
    
    @objc
    private func pushDevicesStoryboard() {
        if let vc = UIStoryboard(name: "Devices", bundle: nil).instantiateInitialViewController() {
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
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "oldRemoteActivated")
        } else {
            UserDefaults.standard.set(false, forKey: "oldRemoteActivated")
        }
        
        // Warning! This re-initializes all ViewControllers in the TabBar (incl. Settings)
        if let vc = tabBarController as? MainViewController {
            vc.useNewRemoteStyle = !sender.isOn
            print("Using \(sender.isOn ? "old" : "new") Remote Layout")
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

extension Notification.Name {
    static let darkModeEnabled = Notification.Name("com.project.DewertOkinMLab2018.darkModeEnabled")
    static let darkModeDisabled = Notification.Name("com.project.DewertOkinMLab2018.darkModeDisabled")

}

class SettingsEntryCell: UITableViewCell, Themeable {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        Themes.setupTheming(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    func setDarkTheme() {
        backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        textLabel?.textColor = .white
    }
    
    func setDefaultTheme() {
        backgroundColor = .white
        textLabel?.textColor = .black
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
}

@objc protocol Themeable {
    @objc func darkModeEnabled(_ notification: Notification)
    @objc func darkModeDisabled(_ notification: Notification)
    func setDarkTheme()
    func setDefaultTheme()
}

class Themes {
    static func setupTheming(for controller: Themeable) {
        NotificationCenter.default.addObserver(controller, selector: #selector(controller.darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(controller, selector: #selector(controller.darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
        if let darkModeEnabled = UserDefaults.standard.object(forKey: "darkModeEnabled") as? Bool {
            if darkModeEnabled {
                controller.setDarkTheme()
            } else {
                controller.setDefaultTheme()
            }
        }
        
    }
}
