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
    // Array(struct) of all achievements in Section 1 of the achievementssection
    var achievementSection1 = [
        achievement(id: 1, title: "achievement1", description: "descriptor1", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 2, title: "achievement2", description: "descriptor2", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 3, title: "achievement3", description: "descriptor3", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 4, title: "achievement4", description: "descriptor4", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 5, title: "achievement5", description: "descriptor5", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 6, title: "achievement6", description: "descriptor6", progress: "5/7undefined", image: "LockedTrophy")
    ]
    var achievementSection2 = [
        achievement(id: 1, title: "achievementsec21", description: "descriptor1", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 2, title: "achievement2", description: "descriptor2", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 3, title: "achievement3", description: "descriptor3", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 4, title: "achievement4", description: "descriptor4", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 5, title: "achievement5", description: "descriptor5", progress: "5/7undefined", image: "LockedTrophy"),
        achievement(id: 6, title: "achievement6", description: "descriptor6", progress: "5/7undefined", image: "LockedTrophy")
    ]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return achievementSections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievementSection1.count
        
    }
    
    class LabelTableViewCell: UITableViewCell {
        @IBOutlet weak var TopicLabel: UILabel!
        @IBOutlet weak var TopicTrophyCountLabel: UILabel!
        
    }
    class AchievementTableViewCell: UITableViewCell {
        @IBOutlet weak var AchievementLabel: UILabel!
        @IBOutlet weak var AchievementDescriptionLabel: UILabel!
        @IBOutlet weak var AchievementProgressLabel: UILabel!
        @IBOutlet weak var AchievementTrophyImageView: UIImageView!
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
                    as! AchievementTableViewCell
        
                let achievement = achievementSection1[indexPath.row]
                cell.AchievementLabel?.text = achievement.title
                cell.AchievementDescriptionLabel?.text = achievement.description
                cell.AchievementProgressLabel?.text = achievement.progress
                cell.AchievementTrophyImageView?.image = UIImage(named: achievement.image)
        
                return cell
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

