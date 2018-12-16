//
//  addTimer.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 13.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import UserNotifications
import NotificationCenter

class AddTimerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var timerToEdit: (Timer, IndexPath)?
    
    @IBOutlet weak var timePicker: UIDatePicker!
    private var saved = false
    @IBOutlet weak var inputTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTableView.delegate = self
        inputTableView.dataSource = self
        inputTableView.tableFooterView = UIView()
        inputTableView.rowHeight = UITableView.automaticDimension
        inputTableView.estimatedRowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let time = timerToEdit?.0.timerTime {
            self.timePicker.date = time
        } else {
            print("WTF")
        }
        
        if let name = timerToEdit?.0.timerName {
            if let cell = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextInputTableViewCell {
                cell.cellTextField.text = name
                print("heya")
                inputTableView.reloadData()
            }
        }
    }
    
    @IBAction func doneTimer(_ sender: Any) {
        
        if let titleText = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextInputTableViewCell {
            if (titleText.cellTextField.hasText) {
                saved = true
                self.performSegue(withIdentifier: "TimerWasAdded", sender: self)
            } else {
                print("Invalid Name")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TimerListViewController else { return }
        guard let titleText = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextInputTableViewCell else { return }
        if(saved){
            
            // If oldTimer is not nil, we need to remove the old timer
            if let oldTimer = timerToEdit {
                guard destination.timerList.contains(oldTimer.0) else {return}
                destination.timerList.remove(at: oldTimer.1.row)
                print("Old timer removed")
            }
            // Adding a new timer
                let newTimer = Timer(context: PersistenceService.context)
                newTimer.timerName = titleText.cellTextField.text
                newTimer.timerTime = timePicker.date
                PersistenceService.saveContext()
                destination.timerList.append(newTimer)

            
        }
        saved = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! TextInputTableViewCell
            cell.cellTitleLabel.text = "Name"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PresetCell", for: indexPath) as! PresetTableViewCell
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPreset)))
            return cell
        default: return UITableViewCell()
        }
    }
    
    @objc
    private func selectPreset() {
        //shall open presets menu/page/sheet to select a preset
        var selectedPreset: String? { didSet {
                setPresetLabel(text: selectedPreset)
            }}
        let alert = UIAlertController(title: "Choose Preset", message: "", preferredStyle: .actionSheet)
        let preset1 = UIAlertAction(title: "Sleeping", style: .default, handler: {action in
            selectedPreset = action.title
        })
        let preset2 = UIAlertAction(title: "Reading", style: .default, handler: {action in
            selectedPreset = action.title
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            selectedPreset = nil
        })
        alert.addAction(preset1)
        alert.addAction(preset2)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        print("Presets Button pressed")

    }
    
    private func setPresetLabel(text: String?) {
        if let title = text, let cell = inputTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PresetTableViewCell {
            cell.presetLabel.text = title
            inputTableView.reloadData()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        inputTableView.reloadData()
        inputTableView.layoutIfNeeded()
    }
}
