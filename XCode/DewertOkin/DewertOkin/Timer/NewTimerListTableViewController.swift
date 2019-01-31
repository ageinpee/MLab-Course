//
//  NewTimerListTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 31.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreBluetooth

class NewTimerListTableViewController: UITableViewController {
    
    //---------------------------------------
    //----- Bluetooth Dependencies ----------
    var remoteControlConfig = RemoteControlConfig()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    lazy var bluetoothBackgroundHandler = BluetoothBackgroundHandler(bluetoothService: self.bluetooth)
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    var bluetoothTimer: Timer?
    
    public var timerList = [DeviceTimer]() {
        didSet {
            if timerList.isEmpty {
                let noDataLabel = BackgroundLabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No timers set"
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                tableView.isScrollEnabled = false
            } else {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
                tableView.isScrollEnabled = true
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scheduleNotifications()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mySwitch = UISwitch()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TimerEntryCell", for: indexPath) as? TimerEntryCell {
            
            cell.textLabel?.text = timerList[indexPath.row].timerName
            cell.detailTextLabel?.text = timerList[indexPath.row].timerTime?.toString(dateFormat: "HH:mm") ?? "Error" + " | "
            cell.accessoryView = mySwitch
            mySwitch.setOn(true,animated:true)
            return cell
        }
        print("Error")
        return TimerEntryCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTimer = timerList[indexPath.row]
        let vc = UINavigationController(rootViewController: AddTimerViewController(deviceTimer: selectedTimer)) 
        present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.timerList.remove(at: indexPath.row)
            let fetchRequest: NSFetchRequest<DeviceTimer> = DeviceTimer.fetchRequest()
            
            do {
                var savedTimer = try PersistenceService.context.fetch(fetchRequest)
                let managedObectContext = PersistenceService.persistentContainer.viewContext
                managedObectContext.delete(savedTimer[indexPath.row])
                savedTimer.remove(at: indexPath.row)
                try managedObectContext.save()
            } catch {
                print("Couldn't delete Timer in Core Data, what the fuck just happened!")
            }
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @objc
    private func presentAddTimerController() {
        present(UINavigationController(rootViewController: AddTimerViewController(deviceTimer: nil)), animated: true, completion: nil)
    }
    
    @objc
    private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(presentAddTimerController))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf))
        navigationItem.title = "Timer"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(TimerEntryCell.self, forCellReuseIdentifier: "TimerEntryCell")

    }
    
    private func getSavedData() {
        guard globalDeviceObject.uuid != "nil" else { return }
        let fetchRequest: NSFetchRequest<DeviceTimer> = DeviceTimer.fetchRequest()
        let predicateUUID = NSPredicate(format: "deviceUUID = %@", globalDeviceObject.uuid)
        fetchRequest.predicate = predicateUUID
        
        do {
            let savedTimer = try PersistenceService.context.fetch(fetchRequest)
            self.timerList = savedTimer
            self.tableView.reloadData()
        } catch {
            print("Couldn't update the TableView, reload!")
        }
    }
    
    private func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        print("Removed all Notifications")
        for timer in timerList {
            let content = UNMutableNotificationContent()
            if let timerName = timer.timerName, let timerTime = timer.timerTime, let repeats = timer.repeatInterval {
                content.title = NSString.localizedUserNotificationString(forKey: timerName, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "Press to execute preset.", arguments: nil)
                
                // Configure the trigger for a 7am wakeup.
                var dateInfo = DateComponents()
                dateInfo.hour = Calendar.current.component(.hour, from: timerTime)
                dateInfo.minute = Calendar.current.component(.minute, from: timerTime)
                var trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                if repeats != RepeatingOptions.never.rawValue && repeats != RepeatingOptions.notSet.rawValue {
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
                }
                
                let presetTimerDate = Date().timeIntervalSince(dateInfo.date ?? Date())
                print("Next Date" + String(presetTimerDate))
                
                Timer.scheduledTimer(withTimeInterval: presetTimerDate, repeats: false) { (timer) in
                    self.triggerMemory1()
                    timer.invalidate()
                }
              
                
                // Create the request object.
                let request = UNNotificationRequest(identifier: timerName, content: content, trigger: trigger)
                
                // Schedule the request.
                center.add(request) { (error : Error?) in
                    if let theError = error {
                        print(theError.localizedDescription)
                    }
                }
                print("Scheduled Notification for timer \(timerName) at \(timerTime) which repeats: \(trigger.repeats)")
            }

        }
    }
    
    func triggerMemory1() {
        guard bluetoothBackgroundHandler.checkStatus() else {
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false){
                (_) in
                if (self.bluetoothBackgroundHandler.checkStatus()) {
                    self.triggerMemory1()
                } else {
                    self.notifyAfterTime()
                }
            }
            return
        }
        self.characteristic = self.bluetooth.writeCharacteristic
        bluetoothTimer?.invalidate()
        bluetoothTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            (_) in
            self.triggerCommand(keycode: keycode.memory1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {self.bluetoothTimer?.invalidate()})
    }
    
    func notifyAfterTime() {
        print("Nothing connected")
    }
    
    func triggerCommand(keycode: keycode) {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        let movement = self.remoteControlConfig.getKeycode(name: keycode)
        bluetooth.connectedPeripheral!.writeValue(movement, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
    }

}

class TimerEntryCell: UITableViewCell, Themeable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        Themes.setupTheming(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    func setDarkTheme() {
        backgroundColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.0)
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .white
    }
    
    func setDefaultTheme() {
        backgroundColor = .white
        textLabel?.textColor = .black
        detailTextLabel?.textColor = .black
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
}

class BackgroundLabel: UILabel, Themeable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Themes.setupTheming(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
    
    func setDarkTheme() {
        backgroundColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.0)
        textColor = .lightGray
    }
    
    func setDefaultTheme() {
        backgroundColor = .white
        textColor = .lightGray
    }
}


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
