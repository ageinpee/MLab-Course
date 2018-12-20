//
//  BluetoothPairingSuccessViewController.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 20.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class BluetoothPairingSuccessViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: { self.showRemote() })
    }
    
    func showRemote() {
        let remoteController = RemoteController()
        self.navigationController?.pushViewController(remoteController, animated: true)
    }
    
}
