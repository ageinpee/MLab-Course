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


class RemoteController: UIViewController, UIGestureRecognizerDelegate {
    
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
    
    var device = globalDeviceObject {
        didSet {
            checkBluetoothConnectivity()
        }
    }
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
    var bluetoothTimer: Timer?
    
    //----------------------------------------
    //--------- Fancy Remote Setup -----------
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutRemote()
        
        self.bluetooth.bluetoothCoordinator = self.bluetoothFlow
        initializeAllCommands()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.layoutRemote()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.layoutRemote()
        arrowsImageView.alpha = 0
        fadeInArrows(withAlpha: opacity)
        
        checkBluetoothConnectivity()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func layoutRemote() {
        let lastConnectedDeviceUUID = UserDefaults.standard.string(forKey: "lastConnectedDevice_uuid")
        if lastConnectedDeviceUUID != "" {
            fetchDevices()
            for d in self.devicesList {
                if d.uuid == lastConnectedDeviceUUID {
                    globalDeviceObject = DeviceObject(withUUID: d.uuid ?? UUID().uuidString,
                                                      named: d.name ?? "error while fetching",
                                                      withHandheldID: d.handheld ?? "no-device",
                                                      withStyle: d.style ?? "filled",
                                                      withExtraFunctions: DeviceObject.convertStringToExtraFunctions(withString: d.extraFunctions ?? "") )
                    self.device = globalDeviceObject
                    break
                }
                else
                {
                    self.device = globalDeviceObject
                }
            }
        }
        
        self.currentDeviceLabel.text = device.name
        self.currentDeviceLabel.isHidden = true
        self.header.topItem?.title = device.name
        self.setupButtons()
        self.setupPanAreas()
        
        self.impact = UIImpactFeedbackGenerator(style: .light)
        
        impact = UIImpactFeedbackGenerator(style: .light)
        
        arrowsImageView.image = device.deviceImages[0]
        Image.image = device.deviceImages[1]
        Image.contentMode = .scaleAspectFit
        
        self.arrowsImageView.image = self.device.deviceImages[0]
        self.Image.image = self.device.deviceImages[1]
        self.Image.contentMode = .scaleAspectFit
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
            self.noConnectionBanner.transform = CGAffineTransform.init(translationX: 0, y: 70)
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
