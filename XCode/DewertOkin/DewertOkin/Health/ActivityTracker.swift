//
//  File.swift
//  DewertOkin
//
//  Created by Jan Robert on 06.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import UserNotifications

class ActivityTrackerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let defaultCellID = "defaultCellID"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "When do you want to be reminded?"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countDownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "30\nmin"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stepperView: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 300
        stepper.stepValue = 5
        stepper.value = 30
        stepper.isEnabled = true
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(stepperDidChangeValue), for: .valueChanged)
        return stepper
    }()
    
    let startStopTrackingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Tracking", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIButton().tintColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleStartStopTracking), for: .touchUpInside)
        return button
    }()
    
    let descriptionStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fillProportionally
        stackview.spacing = 8
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "How does the Activity Reminder work?"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionBodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "The Okin Smart Remote helps you to stay healthy! Leading experts recommend to get up and move around at least once an hour. \n\nThe Okin Smart Remote can remind you to get up after a time which you can specify above. \nIf you leave the Okin Smart Remote open, we can automatically detect your movement through the sensors of your iPhone and the timer will reset by itself. "
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let shapeLayer = CAShapeLayer()
    
    var uiUpdateTimer: Timer?
    
    var activityTimer: Timer?
    
    var remainingTimeInSeconds: TimeInterval = 30 * 60
    
    var countDownSecondsTotal: TimeInterval = 0
    
    var countDownIsRunning: Bool = false {
        didSet {
            if countDownIsRunning {
                startStopTrackingButton.setTitle("Stop Tracking", for: .normal)
                startStopTrackingButton.backgroundColor = .red
            } else {
                startStopTrackingButton.setTitle("Start Tracking", for: .normal)
                startStopTrackingButton.backgroundColor = UIButton().tintColor
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultCellID)
        
        self.navigationItem.title = "Activity Reminder"
        
        collectionView.alwaysBounceVertical = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["activityReminderBackground"])
        if countDownIsRunning {
            shapeLayer.removeAnimation(forKey: "basicAnimation")
            startCircleAnimation(from: 1 - (remainingTimeInSeconds/countDownSecondsTotal))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // FIXME: Has to be moved to AppDelegate
        if countDownIsRunning {
            addBackgroundActivityReminderNotification()
        }
    }
    
    deinit {
        uiUpdateTimer?.invalidate()
        activityTimer?.invalidate()
    }
    
    @objc
    private func handleStartStopTracking() {
        if countDownIsRunning {
            resetCountDown()
        } else {
            startCountDown()
        }
    }
    
    private func startCountDown() {
        startCircleAnimation()
        uiUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
        activityTimer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(checkForActivity), userInfo: nil, repeats: true)
        countDownIsRunning = true
        countDownSecondsTotal = remainingTimeInSeconds
        stepperView.isEnabled = false
        stepperView.tintColor = .lightGray
    }
    
    private func resetCountDown() {
        countDownIsRunning = false
        uiUpdateTimer?.invalidate()
        activityTimer?.invalidate()
        remainingTimeInSeconds = 30 * 60
        shapeLayer.removeAnimation(forKey: "basicAnimation")
        stepperView.isEnabled = true
        stepperView.tintColor = UIButton().tintColor
        self.navigationController?.tabBarItem.badgeValue = nil
    }
    
    private func activityRecognized() {
        uiUpdateTimer?.invalidate()
        activityTimer?.invalidate()
        // set remaining time to user specified value, for now 30*60
        remainingTimeInSeconds = 30 * 60
        shapeLayer.removeAnimation(forKey: "basicAnimation")
        startCountDown()
    }
    
    @objc
    private func updateCountDown() {
        
        if countDownIsRunning {
            self.navigationController?.tabBarItem.badgeValue = String(Int(remainingTimeInSeconds / 60)) + " min"
        } else {
            self.navigationController?.tabBarItem.badgeValue = nil
        }
        
        if !remainingTimeInSeconds.isZero {
            remainingTimeInSeconds -= 1
        } else {
            countDownFinished()
            resetCountDown()
        }
        countDownLabel.text = String(Int(remainingTimeInSeconds / 60)) + "\nmin"
    }
    
    private func countDownFinished() {
        displayForegroundActivityReminderNotification()
    }
    
    @objc
    private func checkForActivity() {
        Health.shared.getStepsForTimeInterval(timeInSeconds: 300) { result in
            guard let result = result else { return }
            print("Result: " + String(result))
            if result <= 50.0 || result.isZero {
                // timer keeps running
                return
            } else {
                // timer resets
                if self.countDownIsRunning {
                    DispatchQueue.main.async {
                        self.activityRecognized()
                    }
                }
            }
        }
    }
    
    @objc
    private func stepperDidChangeValue() {
        remainingTimeInSeconds = stepperView.value * 60
        countDownSecondsTotal = remainingTimeInSeconds
        countDownLabel.text = String(Int(remainingTimeInSeconds / 60)) + "\nmin"
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellID, for: indexPath)
        
        switch indexPath.item {
        case 0:
            cell.addSubview(titleLabel)
            cell.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        case 1:
            cell.addSubview(countDownLabel)
            cell.addConstraint(NSLayoutConstraint(item: countDownLabel, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: countDownLabel, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
            
            cell.addSubview(stepperView)
            cell.addConstraint(NSLayoutConstraint(item: stepperView, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: stepperView, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1.88, constant: 0))
            
            addAnimation(for: cell)
        case 2:
            cell.addSubview(startStopTrackingButton)
            cell.addConstraint(NSLayoutConstraint(item: startStopTrackingButton, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: startStopTrackingButton, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": startStopTrackingButton]))
        case 3:
            descriptionStackView.addArrangedSubview(descriptionTitleLabel)
            descriptionStackView.addArrangedSubview(descriptionBodyLabel)
            
            cell.addSubview(descriptionStackView)
            cell.addConstraint(NSLayoutConstraint(item: descriptionStackView, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: descriptionStackView, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[v0]-24-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": descriptionStackView]))
        default:
            break
        }
        
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.item {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 88)
        case 1:
            return CGSize(width: collectionView.frame.width, height: 400)
        case 2:
            return CGSize(width: collectionView.frame.width, height: 66)
        case 3:
            
            let approximateWidthOfContent = collectionView.frame.width - 32
            
            let size = CGSize(width: approximateWidthOfContent, height: 1000)
            
            //1000 is the large arbitrary values which should be taken in case of very high amount of content
            
            let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
            let estimatedFrame = NSString(string: descriptionBodyLabel.text ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 66)
        default:
            break
        }
        // default
        return CGSize(width: collectionView.frame.width, height: 44)
    }
}
