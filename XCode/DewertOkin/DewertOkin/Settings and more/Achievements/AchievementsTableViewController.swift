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
    
    let achievementTypes: [AchievementType] =
    [
            .onTopOfThings,
            .veteran,
            .undecisive,
            .nightOwl,
            .letThereBeLight,
            .buttonManiac,
            .exerciseApprentice,
            .exerciseManiac,
            .exerciseMaster,
            .firstStreak,
            .streakItHard,
            .streakLikeABoss
    ]
    
    
    
    
    
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
    
    let colors: [UIColor] = [#colorLiteral(red: 0.8039215686, green: 0.4980392157, blue: 0.1960784314, alpha: 1), #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)]
    
    let achievements: [Achievement] = {
        var list: [Achievement] = []
        for element in AchievementModel.achievementDictionary {
            list.append(element.value)
        }
        return list.sorted(by: { (a1, a2) -> Bool in
            return a1.id < a2.id
        })
    }()
    
    lazy var achievementTitles: [String] = achievements.map({ $0.title })
    lazy var achievementDescriptions: [String] = achievements.map({ $0.description })
    lazy var achievementProgress: [Float] = achievements.map({ $0.progress })
    
    let reuseIdentifier = "defaultCell"
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Placeholder Text"
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Achievements"
        
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
        return achievementTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let shapeLayer = CAShapeLayer()
        
        let progressView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let presetView = createAchievementBlock(achievementTitle: achievementTitles[indexPath.row], achievementDescription: achievementDescriptions[indexPath.row], backgroundColor: colors[indexPath.item])
        
        cell.addSubview(presetView)
        cell.addSubview(progressView)
        
        presetView.translatesAutoresizingMaskIntoConstraints = false
        // UNSAFE
        presetView.backgroundColor = colors[indexPath.item]
        presetView.layer.borderColor = colors[indexPath.item].cgColor
        
        //progressView.backgroundColor = colors[indexPath.item].withAlphaComponent(0.3)
        
        
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1(80)]-8-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : presetView, "v1": progressView]))
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : presetView]))
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : progressView]))
        cell.addConstraint(NSLayoutConstraint(item: presetView, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
        let center = CGPoint(x: 40, y: 33)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 30, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.lineCap = .round
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.lineCap = .round
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 1
        

        shapeLayer.lineWidth = 6
        shapeLayer.strokeEnd = 0
        
        progressView.layer.addSublayer(trackLayer)
        progressView.layer.addSublayer(shapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = achievementProgress[indexPath.item]
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        if achievementProgress[indexPath.item] >= 1.0 {
            shapeLayer.fillColor = colors[indexPath.item].cgColor
            shapeLayer.strokeColor = colors[indexPath.item].cgColor
        } else {
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = colors[indexPath.item].cgColor
            shapeLayer.add(basicAnimation, forKey: "basicAnimation")
        }
        
        
        
        return cell
    }
    
    private func createAchievementBlock(achievementTitle: String, achievementDescription: String, backgroundColor: UIColor) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.white.cgColor
        
        // Setup card appearance
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 3
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.6
        
        let titleLabel: UILabel = {
           let label = UILabel()
            label.text = achievementTitle
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = achievementDescription
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.lineBreakMode = .byTruncatingTail
            return label
        }()
        
        view.addSubview(titleLabel)
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 2/3, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        view.addSubview(descriptionLabel)
        view.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 4/3, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: -16))
        
        view.isUserInteractionEnabled = true
        
        return view
    }
}
