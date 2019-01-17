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
    
    var panRecLeft: UIPanGestureRecognizer = UIPanGestureRecognizer()
    var panRecRight: UIPanGestureRecognizer = UIPanGestureRecognizer()
    var pressRecLeft: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    var pressRecRight: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    //----------------------------------------
    //------ Fancy Remote Attributes ---------
    var oldTranslation = 0 //used to define in which direction the old translation was going
    var panState = UIGestureRecognizer.State.ended
    var impact: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()
    
    var deviceType: DeviceType = .NaN
    
    var currentStyle: DeviceStyleManager = DeviceStyleManager()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bluetooth.bluetoothCoordinator = self.bluetoothFlow
        
        deviceType = DeviceType.chair_2Motors
        currentStyle.setFilledStyle(forDevice: deviceType)
        /*device = DeviceObject(withID: 0,
                              named: "Chair 0",
                              withDescription: "HE150",
                              asType: .chair_2Motors,
                              withStyle: currentStyle,
                              withCMDService: CBUUID(string: "62741523-52F9-8864-B1AB-3B3A8D65950B"),
                              withKeycodeUUID: CBUUID(string: "62741525-52F9-8864-B1AB-3B3A8D65950B"),
                              withFeedbackUUID: CBUUID(string: "62741625-52F9-8864-B1AB-3B3A8D65950B"))*/
        
        setupButtons()
        setupPanAreas()
        
        Themes.setupTheming(for: self)

        Health.shared.requestHealthKitPermission()
        
        impact = UIImpactFeedbackGenerator(style: .light)
        
        /*
        let swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(showOldRemote))
        swipeRec.direction = .up
        ExtraFunctionsButtonObj.addGestureRecognizer(swipeRec)
        ExtraFunctionsButtonObj.addTarget(self, action: #selector(showExtraFeaturesView), for: .touchUpInside)
        */
        arrowsImageView.image = currentStyle.stylesImages[0]
        Image.image = currentStyle.stylesImages[1]
        Image.contentMode = .scaleAspectFit
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arrowsImageView.alpha = 0
        animateFade(withAlpha: opacity)
        
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
        let view = UIView(frame: CGRect(x: 0, y: -80, width: self.view.frame.width, height: 80))
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

    /*
    @objc
    private func showExtraFeaturesView() {
        present(UINavigationController(rootViewController: ExtraFeaturesViewController(collectionViewLayout: UICollectionViewFlowLayout())), animated: true, completion: nil)
    }
    */
    
    //---------------------------------------
    //---------- Remote Actions -------------
    /*
    @IBAction func PresetsButton(_ sender: Any) {
        //shall open presets menu/page/sheet to select a preset
        let alert = UIAlertController(title: "Choose Preset", message: "", preferredStyle: .actionSheet)
        let preset1 = UIAlertAction(title: "Sleeping", style: .default, handler: nil)
        let preset2 = UIAlertAction(title: "Reading", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(preset1)
        alert.addAction(preset2)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        print("Presets Button pressed")
    }
    
    @IBAction func ExtraFunctions(_ sender: Any) {
        //maybe a menu with extra functions like massage/ubl/torch etc...
        let alert = UIAlertController(title: "Choose Feature", message: "", preferredStyle: .actionSheet)
        let option1 = UIAlertAction(title: "Massage", style: .default, handler: nil)
        let option2 = UIAlertAction(title: "Under Bed Lighting", style: .default, handler: nil)
        underBedLighting = option2
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        print("Extra Functions Button pressed")
    }
 */
    
    
    //-------------------------------------------
    //--------     Health Kit Funcs     ---------
    

}


enum Translations {
    case began
    case up
    case down
    case ended
}