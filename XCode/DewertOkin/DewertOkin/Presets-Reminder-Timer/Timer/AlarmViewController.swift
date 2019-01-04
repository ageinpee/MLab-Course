//
//  AlarmViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 04.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class AlarmViewController: UIViewController {
    
    let currentTimelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .black
        label.text = Date().toString(dateFormat: "HH:mm")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var alarmTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.text = "Alarm set to \(self.alarmTime.toString(dateFormat: "HH:mm"))"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cancelAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancelAlarmButton), for: .touchUpInside)
        return button
    }()
    
    lazy var presetNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.backgroundColor = .green
        label.text = "Preset \(self.preset ?? "undefined") will be executed"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 25
        label.layer.masksToBounds = true
        return label
    }()
    
    var clockUpdateTimer: Timer?
    
    var preset: String?
    
    var alarmTime: Date = Date().addingTimeInterval(10)
    
    var alarmTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        scheduleAlarm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clockUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.currentTimelabel.text = Date().toString(dateFormat: "HH:mm")
        }
            
        alarmTimer = Timer.scheduledTimer(withTimeInterval: alarmTime.timeIntervalSinceNow, repeats: false, block: { timer in
            weak var pvc = self.presentingViewController
        
            UIView.animate(withDuration: 1, animations: {
                self.presetNameLabel.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height/2)
                self.alarmTimeLabel.alpha = 0
                self.alarmTimeLabel.isHidden = true
            }, completion: { result in
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                    self.dismiss(animated: false, completion: {
                        let vc = ExecutingPresetViewController()
                        vc.preset = self.preset
                        pvc?.present(vc, animated: false, completion: nil)
                        timer.invalidate()
                    })
                })
            })
        })
        
        UIView.animate(withDuration: 1.5, delay: 1, options: [.autoreverse, .repeat], animations: {
            self.presetNameLabel.alpha = 0.6
        })
    }
    
    @objc
    private func handleCancelAlarmButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        self.view.addSubview(currentTimelabel)
        self.view.addSubview(alarmTimeLabel)
        self.view.addSubview(cancelAlarmButton)
        self.view.addSubview(presetNameLabel)
        
        self.view.addConstraint(NSLayoutConstraint(item: currentTimelabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: currentTimelabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 2/3, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: alarmTimeLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: alarmTimeLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 4/3, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: cancelAlarmButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]-32-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": cancelAlarmButton]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": cancelAlarmButton]))
        
        self.view.addConstraint(NSLayoutConstraint(item: presetNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-48-[v0(50)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": presetNameLabel]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": presetNameLabel]))
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clockUpdateTimer?.invalidate()
        alarmTimer?.invalidate()
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["okinAlarm"])
        print("Removed other alarms")
    }
    
    private func scheduleAlarm() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["okinAlarm"])
        print("Removed other alarms")
            let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Your Alarm", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "Press to execute preset.", arguments: nil)
                
                // Configure the trigger
                var dateInfo = DateComponents()
                dateInfo.hour = Calendar.current.component(.hour, from: alarmTime)
                dateInfo.minute = Calendar.current.component(.minute, from: alarmTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                
                // Create the request object.
                let request = UNNotificationRequest(identifier: "okinAlarm", content: content, trigger: trigger)
                
                // Schedule the request.
                center.add(request) { (error : Error?) in
                    if let theError = error {
                        print(theError.localizedDescription)
                    }
                }
                print("Scheduled Notification for alarm at \(alarmTime).")
    }
}
