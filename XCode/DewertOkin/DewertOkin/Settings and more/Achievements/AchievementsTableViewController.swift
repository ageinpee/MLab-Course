//
//  AchievementsTableViewController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 06.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit



class AchievementsTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Achievements"
        //navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    struct achievement {
        // Establishes the basic Structure of achievements with the type of the variables
        var id: Int
        var title: String
        var description: String
        var progress: String
        var image: String
        
    }
    // Array(string) with the name of every achievement-Section for the Labels
    // change these to change the Sectionnames
    var achievementSections = [
        "ButtonAchievements",
        "FunAchievements",
        "Other"
    ]
    // Array(struct) of all the achievements in Section 1 of the achievementssection
    // Change these to change the actual displayed Achievement-Label-Text
    var achievementCollection1: [achievement] = [
        achievement(id: 1, title: "achievement1", description: "descriptor1", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 2, title: "achievement2", description: "descriptor2", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 3, title: "achievement3", description: "descriptor3", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 4, title: "achievement4", description: "descriptor4", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 5, title: "achievement5", description: "descriptor5", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 6, title: "achievement6", description: "descriptor6", progress: "5/7undefined", image: "LockedTrophy")
    ]
    // Array(struct) of all the achievements in Section 2 of the achievementssection
    // Change these to change the actual displayed Achievement-Label-Text
    var achievementCollection2: [achievement] = [
        achievement(id: 1, title: "achievementsec21", description: "descriptor1", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 2, title: "achievement2", description: "descriptor2", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 3, title: "achievement3", description: "descriptor3", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 4, title: "achievement4", description: "descriptor4", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 5, title: "achievement5", description: "descriptor5", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 6, title: "achievement6", description: "descriptor6", progress: "5/7undefined", image: "LockedTrophy")
    ]
    // defines the number of Sections displayed
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // defines the number of rows per section -- it just counts the entries of achievementCollection1 + achievementCollection2 and gives back the appropriate number of rows.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievementCollection1.count + achievementCollection2.count
        
    }
    
    // Here, all Cells-Labels get their appropriate Text.  At the moment, This takes a cell, puts the Text of one entry of "achievementCollection1"-array into the cell, returns the updated cell.
    // TODO: improve it, maybe make it recursive?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementsTableViewCell
            cell.descriptionLabel.text = achievementCollection1[0].description
            cell.titleLabel.text = achievementCollection1[0].title
            cell.progressLabel.text = achievementCollection1[0].progress
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementsTableViewCell
            cell.descriptionLabel.text = achievementCollection1[1].description
            cell.titleLabel.text = achievementCollection1[1].title
            cell.progressLabel.text = achievementCollection1[1].progress
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            return cell
        }
    }
    // defines the height for each row.(achievement)
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    // dummy for achievement triggering
    public static func didTriggerAchievement(clickCount count: Int) {
        if (count >= 5) {
            print("Achievement triggered!")
        }

    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//            as! AchievementTableViewCell
//
//        let achievement = achievementSection1[indexPath.row]
//        cell.AchievementLabel?.text = achievement.title
//        cell.AchievementDescriptionLabel?.text = achievement.description
//        cell.AchievementProgressLabel?.text = achievement.progress
//        cell.AchievementTrophyImageView?.image = UIImage(named: achievement.image)
//
//        return cell
//    }
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

