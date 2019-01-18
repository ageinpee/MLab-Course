//
//  RemoteControllerExtensionCoreData.swift
//  DewertOkin
//
//  Created by Henrik Peters on 17.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreData

extension RemoteController {
    
    func fetchDevices() {
        let fetchRequest: NSFetchRequest<Devices> = Devices.fetchRequest()
        
        do {
            let savedDevices = try PersistenceService.context.fetch(fetchRequest)
            self.devicesList = savedDevices
        } catch {
            print("Couldn't update the Devices, reload!")
        }
    }
    
    
    func saveDevice(withUUID: String, named: String, forHandheldID: String, withStyle: String) {
        let device = Devices(context: PersistenceService.context)
        device.uuid = withUUID
        device.name = named
        device.handheld = forHandheldID
        device.style = withStyle
        PersistenceService.saveContext()
    }
    
    
    
}
