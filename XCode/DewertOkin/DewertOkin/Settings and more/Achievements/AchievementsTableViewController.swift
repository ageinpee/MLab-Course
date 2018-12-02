//
//  AchievementsTableViewController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 06.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit



class AchievementsTableViewController: UITableViewController {
    
    var timestampStart = Date.distantFuture
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        // Do any additional setup after loading the view.
        
        ///-----Achievement "Achievement Veteran"-related-----
        timestampStart = Date()
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
        return AchievementModel.achievementCollection1.count +  1
        
    }
    
    private func createAchievementCell(tableview: UITableView, path: IndexPath) -> UITableViewCell {
        
        if path.row < AchievementModel.achievementCollection1.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: path) as! AchievementsTableViewCell
            cell.descriptionLabel.text = AchievementModel.achievementCollection1[path.row].description
            cell.titleLabel.text = AchievementModel.achievementCollection1[path.row].title
            cell.progressBar.progress = AchievementModel.barButtonClickCountProgess
            cell.achievementImage.image = UIImage(named: AchievementModel.achievementCollection1[path.row].image)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: path)
            return cell
        }
      
    }
    
    // Here, all Cells-Labels get their appropriate Text.  At the moment, This takes a cell, puts the Text of one entry of "achievementCollection1"-array into the cell, returns the updated cell.
    // TODO: improve it, maybe make it recursive?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return createAchievementCell(tableview: tableView, path: indexPath)
        
//        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementsTableViewCell
//            cell.descriptionLabel.text = AchievementModel.achievementCollection1[0].description
//            cell.titleLabel.text = AchievementModel.achievementCollection1[0].title
//            cell.progressBar.progress = AchievementModel.barButtonClickCountProgess
//            cell.achievementImage.image = UIImage(named: AchievementModel.achievementCollection1[0].image)
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementsTableViewCell
//            cell.descriptionLabel.text = AchievementModel.achievementCollection1[1].description
//            cell.titleLabel.text = AchievementModel.achievementCollection1[1].title
//            cell.progressBar.progress = AchievementModel.reminderSetProgress
//            cell.achievementImage.image = UIImage(named: AchievementModel.achievementCollection1[1].image)
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementsTableViewCell
//            cell.descriptionLabel.text = AchievementModel.achievementCollection1[2].description
//            cell.titleLabel.text = AchievementModel.achievementCollection1[2].title
//            cell.progressBar.progress = AchievementModel.timeSpentInAppProgress
//            cell.achievementImage.image = UIImage(named: AchievementModel.achievementCollection1[2].image)
//            return cell
//        case 4:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementsTableViewCell
//            cell.descriptionLabel.text = AchievementModel.achievementCollection1[3].description
//            cell.titleLabel.text = AchievementModel.achievementCollection1[3].title
//            cell.progressBar.progress = AchievementModel.upDownClickCountUnlocked
//            cell.achievementImage.image = UIImage(named: AchievementModel.achievementCollection1[3].image)
//            return cell
//        case 5:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementsTableViewCell
//            cell.descriptionLabel.text = AchievementModel.achievementCollection1[4].description
//            cell.titleLabel.text = AchievementModel.achievementCollection1[4].title
//            cell.progressBar.progress = AchievementModel.nightOwlProgress
//            cell.achievementImage.image = UIImage(named: AchievementModel.achievementCollection1[4].image)
//            return cell
//        case 6:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementsTableViewCell
//            cell.descriptionLabel.text = AchievementModel.achievementCollection1[5].description
//            cell.titleLabel.text = AchievementModel.achievementCollection1[5].title
//            cell.progressBar.progress = AchievementModel.lightProgess
//            cell.achievementImage.image = UIImage(named: AchievementModel.achievementCollection1[5].image)
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
//            return cell
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

