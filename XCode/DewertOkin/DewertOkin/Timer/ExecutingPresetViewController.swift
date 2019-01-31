//
//  ExecutingPresetViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 04.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//
// Does not currently get used in our app

import Foundation
import UIKit

class ExecutingPresetViewController: UIViewController {
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Moving device into preset position"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = self.view.tintColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        return button
    }()
    
    let successLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.text = "✓"
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private var dirtyTimer: Timer?
    
    var preset: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.executePreset()
        dirtyTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { timer in
            self.doneButton.isEnabled = true
            self.doneButton.alpha = 1
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.successLabel.isHidden = false
            self.descriptionLabel.isHidden = true
        })
    }
    
    private func setupViews() {
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(doneButton)
        self.view.addSubview(successLabel)
        
        self.view.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 2/3, constant: 0))
        
          self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": descriptionLabel]))
        
        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: successLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: successLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
    
        self.view.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]-32-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": doneButton]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": doneButton]))
    }
    
    private func executePreset() {
        // TODO: Implement preset execution
    }
    
    @objc
    private func handleDoneButton() {
        self.dismiss(animated: true)
    }
}
