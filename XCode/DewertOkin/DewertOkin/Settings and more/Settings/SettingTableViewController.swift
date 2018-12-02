//
//  SettingTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 06.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    private let settingsEntries: [SettingsEntry] = [.deviceInfo, .achievements, .presets, .useOldRemote,
                           .accessibilityMode, .accessories, .about, .siri, .darkMode]
    
    private let search = UISearchController(searchResultsController: nil)
    
    
    //-----Achievement "Button Maniac"-related-----
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBAction func barButtonClicked(_ sender: UIBarButtonItem) {
        AchievementModel.updateButtonClickCount()
        AchievementModel.saveAchievementProgress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Sets the title of the surrounding Navigation Controller
        navigationItem.title = "More"
        //navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
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
            let darkModeSwitch = UISwitch()
            darkModeSwitch.isOn = false
            darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchChanged(sender:)), for: .valueChanged)
            cell.accessoryView = darkModeSwitch
        }
        
        if (indexPath.row == settingsEntries.firstIndex(of: .accessibilityMode)) {
            let accessibilityModeSwitch = UISwitch()
            accessibilityModeSwitch.isOn = false
            accessibilityModeSwitch.addTarget(self, action: #selector(accessibilityModeSwitchChanged(sender:)), for: .valueChanged)
            cell.accessoryView = accessibilityModeSwitch
        }
        
        if (indexPath.row == settingsEntries.firstIndex(of: .useOldRemote)) {
            let oldRemoteSwitch = UISwitch()
            oldRemoteSwitch.isOn = false
            oldRemoteSwitch.addTarget(self, action: #selector(oldRemoteSwitchChanged(sender:)), for: .valueChanged)
            cell.accessoryView = oldRemoteSwitch
        }
        
        if (indexPath.row == settingsEntries.firstIndex(of: .deviceInfo)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .presets)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .achievements)) {
            cell.accessoryType = .disclosureIndicator
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushAchievementsStoryboard)))
        } else if (indexPath.row == settingsEntries.firstIndex(of: .warranty)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .about)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .siri)) {
            cell.accessoryType = .disclosureIndicator
        } else if (indexPath.row == settingsEntries.firstIndex(of: .accessories)) {
            cell.accessoryType = .disclosureIndicator
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushAccessoriesStoryboard)))
        }
        // Configure the cell...

        return cell
    }
    
    @objc
    private func darkModeSwitchChanged(sender: UISwitch!) {
        if(!sender.isOn) {
            AchievementModel.lightAchievementUnlocked()
        }
        print("Dark Mode switch is on: \(sender.isOn)")
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
