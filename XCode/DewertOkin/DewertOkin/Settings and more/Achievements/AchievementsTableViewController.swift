//
//  AchievementsTableViewController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 06.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit



class AchievementsTableViewController: UITableViewController, Themeable {

    
    
    var timestampStart = Date.distantFuture
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        Themes.setupTheming(for: self)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(dismissSelf)), animated: false)
        
        ///-----Achievement "Achievement Veteran"-related-----
        timestampStart = Date()
    }
    
    @objc
    private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        ///-----Achievement "Achievement Veteran"-related-----
        let timestampFinish = Date()
        let timeIntervall = timestampFinish.timeIntervalSince(timestampStart)
        AchievementModel.updateTimeSpentInAchievements(elapsedTime: timeIntervall)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Achievements"
        //navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
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
    

    
    // Array(string) with the name of every achievement-Section for the Labels
    // change these to change the Sectionnames
    var achievementSections = [
        "ButtonAchievements",
        "FunAchievements",
        "Other"
    ]
    
    
 
    // defines the number of Sections displayed
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // defines the number of rows per section -- it just counts the entries of achievementCollection1 + achievementCollection2 and gives back the appropriate number of rows.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AchievementModel.achievementDictionary.count
        
    }
    // cellForRowAt indexPath iterates through this array and determines the order in which they are displayed
    let achievementTypes: [AchievementType] = [.onTopOfThings, .veteran, .undecisive, .nightOwl, .letThereBeLight, .buttonManiac]
    
    private func createAchievementCell(tableview: UITableView, path: IndexPath) -> UITableViewCell {
        
        if path.row < AchievementModel.achievementDictionary.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: path) as! AchievementsTableViewCell
            if let currentAchievement = AchievementModel.achievementDictionary[achievementTypes[path.row]] {
                cell.descriptionLabel.text = currentAchievement.description
                cell.titleLabel.text = currentAchievement.title
                cell.progressBar.progress = currentAchievement.progress
                cell.achievementImage.image = UIImage(named: currentAchievement.image)
            }
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: path)
        }
      
    }
    
    // Here, all Cells-Labels get their appropriate Text.  At the moment, This takes a cell, puts the Text of one entry of "achievementCollection1"-array into the cell, returns the updated cell.
    // TODO: improve it, maybe make it recursive?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return createAchievementCell(tableview: tableView, path: indexPath)
    }

}

