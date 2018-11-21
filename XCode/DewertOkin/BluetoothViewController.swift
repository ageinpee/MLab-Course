//
//  BluetoothViewController.swift
//  DewertOkin
//
//  Created by Danial Bagheri on 11.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var centralManager: CBCentralManager!
    var dwertOkinControllerPeripheral: CBPeripheral!
    var pickerData: [String] = [String]()
    @IBOutlet weak var devicePicker: UIPickerView!

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    override func viewDidLoad() {
        print("--------viewDidLoad-------")
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        devicePicker.delegate = self
        devicePicker.dataSource = self
//        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        let colors = ["Red","Yellow","Green","Blue"]

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("--------viewWillAppear-------")
        super.viewWillAppear(animated)
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBAction func btn1(_ sender: Any) {
        
        label1.text = "-----";
    }
}


extension BluetoothViewController: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if (peripheral.identifier.uuidString == "153222D8-A953-2297-1EC4-30436ED0D5A3"){
            print("----dada------")
            pickerData.append(peripheral.identifier.uuidString)
            devicePicker.reloadAllComponents()

            print(peripheral)
            dwertOkinControllerPeripheral = peripheral;
            dwertOkinControllerPeripheral.delegate = self
            centralManager.stopScan()
            centralManager.connect(dwertOkinControllerPeripheral)
//        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connect")
        dwertOkinControllerPeripheral.discoverServices(nil);
    }
}

extension BluetoothViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print("**********")
            print(service)
            print("EEEEEEEEE")
            print(service.uuid.uuidString)
            print("EEEEEEEEE")
            peripheral.discoverCharacteristics(nil, for: service)
            //            if (service.uuid.uuidString == "62741523-52F9-8864-B1AB-3B3A8D65950B") {
            //                print("in if uuid of service --- discover chars")
            //                peripheral.discoverCharacteristics(nil, for: service)
            //            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("-------- chars ---------")
            print(characteristic)
            
            //            if characteristic.properties.contains(.read) {
            //                print("\(characteristic.uuid): properties contains .read")
            //            }
            //            if characteristic.properties.contains(.notify) {
            //                print("\(characteristic.uuid): properties contains .notify")
            //            }
            
            peripheral.readValue(for: characteristic)
            //            peripheral.writeValue(0x00040000, for: characteristic)
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        print("char valueeeeeee")
        print(characteristic.value ?? "no value")
    }
    
}
