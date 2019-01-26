//
//  RemoteController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import CoreBluetooth
import CoreData
import Intents


class RemoteController: UIViewController, UIGestureRecognizerDelegate, Themeable{
    
    //----------------------------------------
    //------ Fancy Remote UI-Elements --------
    @IBOutlet weak var PresetsButtonObj: UIButton!
    @IBOutlet weak var ExtraFunctionsButtonObj: UIButton!
    @IBOutlet weak var TimerButtonObj: UIButton!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var arrowsImageView: UIImageView!
    @IBOutlet weak var leftPanArea: UIView!
    @IBOutlet weak var rightPanArea: UIView!
    @IBOutlet weak var currentDeviceLabel: UILabel!
    @IBOutlet weak var devicesListButton: UIButton!
    @IBOutlet weak var header: UINavigationBar!
    
    var panRecLeft: UIPanGestureRecognizer = UIPanGestureRecognizer()
    var panRecRight: UIPanGestureRecognizer = UIPanGestureRecognizer()
    var pressRecLeft: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    var pressRecRight: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    //----------------------------------------
    //------ Fancy Remote Attributes ---------
    var oldTranslation = 0 //used to define in which direction the old translation was going
    var panState = UIGestureRecognizer.State.ended
    var impact: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()
    
    var devicesList = [Devices]()
    
    var device: DeviceObject = DeviceObject()
    var opacity = CGFloat(0.75)
    
    var statusBarStyle: UIStatusBarStyle = .default
    var underBedLighting: UIAlertAction?
    
    var recognizerState: UIGestureRecognizer.State = .ended
    var timer: Timer?
    var translation: Translations = .ended
    
    //---------------------------------------
    //----- Bluetooth Dependencies ----------
    var remoteControlConfig = RemoteControlConfig()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    lazy var bluetoothBackgroundHandler = BluetoothBackgroundHandler(bluetoothService: self.bluetooth)
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    
    //----------------------------------------
    //--------- Fancy Remote Setup -----------
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    //----------------------------------------
    //--------- Siri -------------------------
    let siriControl = SiriController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bluetooth.bluetoothCoordinator = self.bluetoothFlow
        
        device = globalDeviceObject
        
        currentDeviceLabel.text = device.name
        currentDeviceLabel.isHidden = true
        header.topItem?.title = device.name
        setupButtons()
        setupPanAreas()
        
        Themes.setupTheming(for: self)

        Health.shared.requestHealthKitPermission()
        
        impact = UIImpactFeedbackGenerator(style: .light)
        
        arrowsImageView.image = device.deviceImages[0]
        Image.image = device.deviceImages[1]
        Image.contentMode = .scaleAspectFit
    }
    
    @IBAction func moveHeadUpActivity(sender: UIButton) {
        let activity = NSUserActivity(activityType: "de.uhh.mlabdewertokin.command")
        activity.title = "Move Head Up"
        //activity.userInfo = ["head" : "up"]
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier("de.uhh.mlabdewertokin.command")
        } else {
            // Fallback on earlier versions
        }
        view.userActivity = activity
        activity.becomeCurrent()
        
        itDidWork()
    }
    
    func itDidWork(){
        print("aha")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arrowsImageView.alpha = 0
        fadeInArrows(withAlpha: opacity)
        
        checkBluetoothConnectivity()
    }
    
    @objc
    private func showOldRemote() {
        print("Swipe recognized")
        let storyBoard: UIStoryboard = UIStoryboard(name: "OldRemote", bundle: nil)
        let newViewController = storyBoard.instantiateInitialViewController() as! OldRemoteViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    lazy var noConnectionBanner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -90, width: self.view.frame.width, height: 80))
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.7
        return view
    }()
    
    let noConnectionLabel: UILabel = {
        let label = UILabel()
        label.text = "No device connected."
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func checkBluetoothConnectivity() {
        if !bluetoothBackgroundHandler.checkStatus() {
            showNoConnectionBanner()
        } else {
            dismissNoConnectionBanner()
        }
    }
    
    private func showNoConnectionBanner() {
        guard !self.view.subviews.contains(noConnectionBanner) else {return}
        self.view.addSubview(noConnectionBanner)
        noConnectionBanner.addSubview(noConnectionLabel)
        noConnectionBanner.addConstraint(NSLayoutConstraint.init(item: noConnectionLabel, attribute: .centerX, relatedBy: .equal, toItem: noConnectionBanner, attribute: .centerX, multiplier: 1, constant: 0))
        noConnectionBanner.addConstraint(NSLayoutConstraint.init(item: noConnectionLabel, attribute: .centerY, relatedBy: .equal, toItem: noConnectionBanner, attribute: .centerY, multiplier: 3/2, constant: 0))
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.noConnectionBanner.transform = CGAffineTransform.init(translationX: 0, y: 80)
        }) { (_) in
        }
    }
    
    private func dismissNoConnectionBanner() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.noConnectionBanner.transform = CGAffineTransform.init(translationX: 0, y: -80)
        }) { (_) in
            self.noConnectionBanner.removeFromSuperview()
        }
    }
}


enum Translations {
    case began
    case up
    case down
    case ended
}
