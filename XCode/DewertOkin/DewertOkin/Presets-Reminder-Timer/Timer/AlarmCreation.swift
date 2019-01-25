//
//  AlarmCreation.swift
//  DewertOkin
//
//  Created by Jan Robert on 05.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class AlarmCreationViewController: UIViewController {
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.setDate(Date(), animated: true)
        datePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "When do you want the alarm to sound?"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let cancelAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancelAlarmButton), for: .touchUpInside)
        return button
    }()
    
    let selectPresetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Preset to Execute", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIButton().tintColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSelectPresetButton), for: .touchUpInside)
        return button
    }()
    
    let startAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Set Alarm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleStartAlarmButton), for: .touchUpInside)
        return button
    }()
    
    private var selectedTime = Date()
    
    private var selectedPreset = "Sleeping"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        self.view.addSubview(datePicker)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(cancelAlarmButton)
        self.view.addSubview(selectPresetButton)
        self.view.addSubview(startAlarmButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 2/3, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[v0(60)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": descriptionLabel]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": descriptionLabel]))
        
        self.view.addConstraint(NSLayoutConstraint(item: cancelAlarmButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]-32-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": cancelAlarmButton]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": cancelAlarmButton]))
        
        self.view.addConstraint(NSLayoutConstraint(item: startAlarmButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]-32-[v1]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": startAlarmButton, "v1" : cancelAlarmButton]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": startAlarmButton]))
        
        self.view.addConstraint(NSLayoutConstraint(item: selectPresetButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]-16-[v1]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": selectPresetButton, "v1" : startAlarmButton]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": selectPresetButton]))
    }
    
    @objc
    private func datePickerChangedValue(sender: UIDatePicker) {
        selectedTime = sender.date
    }
    
    @objc
    private func handleSelectPresetButton() {
   
    }
    
    @objc
    private func handleStartAlarmButton() {
        let vc = AlarmViewController()
        vc.alarmTime = selectedTime
        vc.preset = selectedPreset
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            pvc?.present(vc, animated: false, completion: nil)
        })
    }
    
    @objc
    private func handleCancelAlarmButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
