//
//  ViewController.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 19.11.18.
//  Copyright © 2018 Nima Rahrakhshan. All rights reserved.
//

import UIKit
import CoreBluetooth

class Bluetooth: UIViewController {
    
    var centralManager: CBCentralManager!
    var dewertOkinControllerPeripheral: CBPeripheral!
    var commandService = CBUUID(string: "62741523-52F9-8864-B1AB-3B3A8D65950B")
    var keyCode = CBUUID(string: "62741525-52F9-8864-B1AB-3B3A8D65950B")
    var dataSource: [CBPeripheral] = [CBPeripheral]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}


extension Bluetooth: CBCentralManagerDelegate {
    
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
        
        // This is not good practice, we should match it with the UUID ( Can't implement it, since I dont have access to it rn)
        print(peripheral.name ?? "")
        let deviceName = peripheral.name ?? ""
        if (isOkinDevice(name:deviceName)){
            dewertOkinControllerPeripheral = peripheral;
            dewertOkinControllerPeripheral.delegate = self
            dataSource.append(peripheral)
            central.stopScan()
            central.connect(dewertOkinControllerPeripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection to control unit established")
        dewertOkinControllerPeripheral.discoverServices(nil);
    }
    
    // This should be deleted after the didDiscover function was reworked
    func isOkinDevice(name: String) -> Bool {
        if (name.lowercased().range(of:"okin") != nil) {
            print("The Dewert Okin device was found")
            return true;
        }
        
        return false;
    }
}

extension Bluetooth: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            if(service.uuid == commandService){
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if( characteristic.uuid.uuidString == "62741525-52F9-8864-B1AB-3B3A8D65950B") {
            let moveUp = getKeycode(name: keycode.m1Out)
            peripheral.writeValue(moveUp, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    // This should'nt be used from outside the class
    // define extra getter for the desired feature (e.g. storeMemoryPosition getter)
    private func getKeycode(name: keycode) -> Data {
        switch name {
        case .m1Out: return Data(bytes:[0x04,0x02,0x00,0x00,0x00,0x01])
        case .m1In: return Data(bytes:[0x04,0x02,0x00,0x00,0x00,0x02])
        case .m2Out: return Data(bytes:[0x04,0x02,0x00,0x00,0x00,0x04])
        case .m2In: return Data(bytes:[0x04,0x02,0x00,0x00,0x00,0x08])
        case .m3Out: return Data(bytes:[0x04,0x02,0x00,0x00,0x00,0x10])
        case .m3In: return Data(bytes:[0x04,0x02,0x00,0x00,0x00,0x20])
        case .m4Out: return Data(bytes:[0x04,0x02,0x00,0x00,0x00,0x40])
        case .m4In: return Data(bytes:[0x04,0x02,0x00,0x00,0x00,0x80])
        case .sync: return Data(bytes:[0x04,0x02,0x00,0x00,0x01,0x00])
        case .socket: return Data(bytes:[0x04,0x02,0x00,0x00,0x02,0x00])
        case .massageStop: return Data(bytes:[0x04,0x02,0x00,0x00,0x04,0x00])
        case .massageHeadPlus: return Data(bytes:[0x04,0x02,0x00,0x00,0x08,0x00])
        case .memory1: return Data(bytes:[0x04,0x02,0x00,0x00,0x10,0x00])
        case .memory2: return Data(bytes:[0x04,0x02,0x00,0x00,0x20,0x00])
        case .memory3: return Data(bytes:[0x04,0x02,0x00,0x00,0x40,0x00])
        case .memory4: return Data(bytes:[0x04,0x02,0x00,0x00,0x80,0x00])
        case .storeMemoryPosition: return Data(bytes:[0x04,0x02,0x00,0x01,0x00,0x00])
        case .ubl: return Data(bytes:[0x04,0x02,0x00,0x02,0x00,0x00])
        case .torch: return Data(bytes:[0x04,0x02,0x00,0x04,0x00,0x00])
        case .massageHead: return Data(bytes:[0x04,0x02,0x00,0x08,0x00,0x00])
        case .massageFeet: return Data(bytes:[0x04,0x02,0x00,0x10,0x00,0x00])
        case .massageAll: return Data(bytes:[0x04,0x02,0x00,0x20,0x00,0x00])
        case .massageFeetPlus: return Data(bytes:[0x04,0x02,0x00,0x40,0x00,0x00])
        case .massageHeadMinus: return Data(bytes:[0x04,0x02,0x00,0x80,0x00,0x00])
        case .massageFeetMinus: return Data(bytes:[0x04,0x02,0x01,0x00,0x00,0x00])
        case .empty: return Data(bytes:[0x04,0x02,0x02,0x00,0x00,0x00])
        case .massageWave: return Data(bytes:[0x04,0x02,0x04,0x00,0x00,0x00])
        case .safetyChild: return Data(bytes:[0x04,0x02,0x08,0x00,0x00,0x00])
        case .allFlat: return Data(bytes:[0x04,0x02,0x10,0x00,0x00,0x00])
        case .massage1: return Data(bytes:[0x04,0x02,0x10,0x00,0x00,0x00])
        case .massage2: return Data(bytes:[0x04,0x02,0x20,0x00,0x00,0x00])
        case .massage3: return Data(bytes:[0x04,0x02,0x40,0x00,0x00,0x00])
            //default: return []
        }
    }
}

enum keycode {
    case m1Out
    case m1In
    case m2Out
    case m2In
    case m3Out
    case m3In
    case m4Out
    case m4In
    case sync
    case socket
    case massageStop
    case massageHeadPlus
    case memory1
    case memory2
    case memory3
    case memory4
    case storeMemoryPosition
    case ubl
    case torch
    case massageHead
    case massageFeet
    case massageAll
    case massageFeetPlus
    case massageHeadMinus
    case massageFeetMinus
    case empty
    case massageWave
    case safetyChild
    case allFlat
    case massage1
    case massage2
    case massage3
}
