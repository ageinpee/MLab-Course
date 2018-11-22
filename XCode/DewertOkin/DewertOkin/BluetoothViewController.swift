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
    var dataSource: [CBPeripheral] = [CBPeripheral]()
    @IBOutlet weak var devicePicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let deviceName = dataSource[row].name ?? ""
        return deviceName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("--------change option-------")
        if (dataSource.count > 0) {
            dwertOkinControllerPeripheral = dataSource[row];
            dwertOkinControllerPeripheral.delegate = self
        }
    }
    
    override func viewDidLoad() {
        print("--------viewDidLoad-------")
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        devicePicker.delegate = self
        devicePicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("--------viewWillAppear-------")
        super.viewWillAppear(animated)
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBAction func btn1(_ sender: Any) {
        print("----btn pressed------")
        
        centralManager.stopScan()
        centralManager.connect(dwertOkinControllerPeripheral)
        dwertOkinControllerPeripheral.discoverServices(nil);
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
        
        print("----dada------")
        print(peripheral.name ?? "")
        let deviceName = peripheral.name ?? ""
        if (isOkinDevice(name:deviceName)){
            dwertOkinControllerPeripheral = peripheral;
            dwertOkinControllerPeripheral.delegate = self
            dataSource.append(peripheral)
            devicePicker.reloadAllComponents()
        }
        
        
        
        //            print(peripheral)
        //            dwertOkinControllerPeripheral = peripheral;
        //            dwertOkinControllerPeripheral.delegate = self
        //            centralManager.stopScan()
        //            centralManager.connect(dwertOkinControllerPeripheral)
        //        }
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connect")
        dwertOkinControllerPeripheral.discoverServices(nil);
    }
    
    func isOkinDevice(name: String) -> Bool {
        if (name.lowercased().range(of:"okin") != nil) {
            print("is okin")
            return true;
        }
        
        return false;
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
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("-------- chars ---------")
            print(characteristic)
            //            if (characteristic.uuid.uuidString == "1720") {
            //                print("-------- if done ---------")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            //
            //            if (characteristic.uuid.uuidString == "62741625-52F9-8864-B1AB-3B3A8D65950B") {
            //                print("-------- if done ---------")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            //
            //            if (characteristic.uuid.uuidString == "662741525-52F9-8864-B1AB-3B3A8D65950") {
            //                print("-------- if done ---------")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            ////
            //            if (characteristic.uuid.uuidString == "1721") {
            //                print("TTTTTTTTTTTTTTTTTTT if doneTTTTTTTTT")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            //
            //            if (characteristic.uuid.uuidString == "1821") {
            //                print("************** if done **********")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            //
            //            if (characteristic.uuid.uuidString == "1820") {
            //                print("%%%%%%%% if done %%%%%%%%%%%")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            //
            //            if (characteristic.uuid.uuidString == "90311725-25FA-3346-12EF-3CFB7A2556AC") {
            //                print("%%%%%%%% if done %%%%%%%%%%%")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            //
            //            if (characteristic.uuid.uuidString == "00001534-1212-EFDE-1523-785FEABCD123") {
            //                print("%%%%%%%% if done %%%%%%%%%%%")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            
            //Turns on the lamp
            if (characteristic.uuid.uuidString == "00001532-1212-EFDE-1523-785FEABCD123") {
                print("%%%%%%%% if done %%%%%%%%%%%")
                let bytes : [UInt8] = [ 0x04, 0x04, 0x000 ]
                let data = Data(bytes:bytes)
                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withResponse)
            }
            //
            //            if (characteristic.uuid.uuidString == "00001531-1212-EFDE-1523-785FEABCD123") {
            //                print("%%%%%%%% if done %%%%%%%%%%%")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            ////
            //            if (characteristic.uuid.uuidString == "90311625-25FA-3346-12EF-3CFB7A2556AC") {
            //                print("%%%%%%%% if done %%%%%%%%%%%")
            //
            //                let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //                let data = Data(bytes:bytes)
            //                peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            //            }
            
            
            //Turn lamp on
            //            let bytes : [UInt8] = [ 0x00, 0x04, 0x000 ]
            //            let data = Data(bytes:bytes)
            //            peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withoutResponse)
            
            //            let bytes : [UInt8] = [ 0x04, 0x02, 0x00,0x02, 0x00, 0x00]
            //            let data = Data(bytes:bytes)
            //            peripheral.writeValue(data, for: characteristic, type:  CBCharacteristicWriteType.withResponse)
            
            //            if characteristic.properties.contains(.read) {
            //                print("\(characteristic.uuid): properties contains .read")
            //            }
            //            if characteristic.properties.contains(.notify) {
            //                print("\(characteristic.uuid): properties contains .notify")
            //            }
            
            //            peripheral.readValue(for: characteristic)
            //            peripheral.writeValue(0x00040000, for: characteristic)
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Replayyyyyyyy 000000))))))))))))))))))))))))))))))")
        print(characteristic)
    }
    
}
