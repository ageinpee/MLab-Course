//
//  RemoteControllerExtensionDarkMode.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension RemoteController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    func setDarkTheme() {
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        //self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.tabBarController?.tabBar.barStyle = UIBarStyle.black
        statusBarStyle = .lightContent
        self.currentDeviceLabel.textColor = .white
        self.stepsLabel.textColor = .white
        self.PresetsButtonObj.setTitleColor(UIColor.orange, for: .normal)
        self.TimerButtonObj.setTitleColor(UIColor.orange, for: .normal)
        self.ExtraFunctionsButtonObj.setTitleColor(UIColor.orange, for: .normal)
    }
    
    func setDefaultTheme() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = nil
        self.navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.tabBarController?.tabBar.barStyle = UIBarStyle.default
        statusBarStyle = .default
        self.currentDeviceLabel.textColor = .black
        self.stepsLabel.textColor = .black
        self.PresetsButtonObj.setTitleColor(nil, for: .normal)
        self.TimerButtonObj.setTitleColor(nil, for: .normal)
        self.ExtraFunctionsButtonObj.setTitleColor(nil, for: .normal)
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
}
