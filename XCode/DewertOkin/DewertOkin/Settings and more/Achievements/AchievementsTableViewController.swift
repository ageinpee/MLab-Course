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

class AchievementsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
//    let achievements: [Achievement] = [ AchievementModel.achievementDictionary[AchievementType.exerciseApprentice]! ]
    
    let achievements: [Achievement] = {
        var list: [Achievement] = []
        for element in AchievementModel.achievementDictionary {
            list.append(element.value)
        }
        return list
    }()
    
    lazy var achievementList: [String] = achievements.map({ $0.title })
    
    let reuseIdentifier = "defaultCell"
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Placeholder Text"
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    @objc
    private func test() {
        print("Success")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Achievements"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf(_:)))
        
        collectionView.alwaysBounceVertical = true
    }
    
    @objc
    private func dismissSelf(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if indexPath.row == 0 {
            cell.addSubview(descriptionLabel)
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : descriptionLabel]))
            cell.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        } else {
            let buttonTitle = achievementList[indexPath.row - 1]
            let newButton = createPresetButton(buttonTitle: buttonTitle)
            cell.addSubview(newButton)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : newButton]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : newButton]))
            cell.addConstraint(NSLayoutConstraint(item: newButton, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        }
        
        //cell.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        return cell
    }
    
    private func createPresetButton(buttonTitle: String) -> UIButton {
        let button = UIButton()
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = collectionView.tintColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: button.contentEdgeInsets.top + 5, left: button.contentEdgeInsets.left + 5, bottom: button.contentEdgeInsets.bottom + 5, right: button.contentEdgeInsets.right + 5)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
        return button
    }
}
