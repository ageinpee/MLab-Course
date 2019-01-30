//
//  NewPresetsController.swift
//  DewertOkin
//
//  Created by Jan Robert on 13.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreData

class PresetsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PresetButtonDelegate {
    
    var remoteControlConfig = RemoteControlConfig()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    lazy var bluetoothBackgroundHandler = BluetoothBackgroundHandler(bluetoothService: self.bluetooth)
    var bluetoothTimer: Timer?
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    
    let memoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Memory positions"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let otherPresetDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Other presets"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tutorialLabel: UILabel = {
       let label = UILabel()
        label.text = "Press and hold a preset to edit"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote).withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let defaultCell = "defaultCell"
    let presetButtonCell = "presetButtonCell"

    let controlUnitPresets = globalDeviceObject.availableMemories.map { $0.rawValue }
    /*var phonePresetsNames = ["Sleep", "Relax", "Flat"] {
        didSet {
            collectionView.reloadSections([3])
        }
    }*/
    
    let colors: [UIColor] = [#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)]
    
    var presetsList = [Preset]() {
        didSet {
            collectionView.reloadSections([3])
        }
    }
    
    override func viewDidLoad() {
        collectionView.register(PresetButtonCell.self, forCellWithReuseIdentifier: presetButtonCell)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultCell)
        
        collectionView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        collectionView.alwaysBounceVertical = true
        
        self.navigationItem.title = "Memory"
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf)), animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getSavedPresets()
    }
    
    @objc
    private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func handleBackgroundTap() {
        print("Background tapped")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if controlUnitPresets.count == 0 {
                return 0
            }
            return 1
        case 1:
            return controlUnitPresets.count
        case 2:
            return 1
        case 3:
            return presetsList.count + 1
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            // Description Label for presets on the control unit
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCell, for: indexPath)
            cell.contentView.addSubview(memoryDescriptionLabel)
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : memoryDescriptionLabel]))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : memoryDescriptionLabel]))
            return cell
        case 1:
            // Presets on the control unit
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presetButtonCell, for: indexPath) as? PresetButtonCell {
                cell.presetName = controlUnitPresets[indexPath.item]
                cell.delegate = self
                cell.layer.borderColor = cell.backgroundColor?.cgColor
                return cell
            }
            return PresetButtonCell()
        case 2:
            // Description Label for presets on the iPhone
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCell, for: indexPath)
            cell.contentView.addSubview(otherPresetDescriptionLabel)
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : otherPresetDescriptionLabel]))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : otherPresetDescriptionLabel]))
            return cell
        case 3:
            // Presets on the iPhone
            
            switch indexPath.item {
            case presetsList.count:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presetButtonCell, for: indexPath) as? PresetButtonCell {
                    cell.presetName = "New Preset"
                    cell.delegate = self
                    cell.presetNameLabel.text = "+"
                    cell.presetNameLabel.font = UIFont.preferredFont(forTextStyle: .headline).withSize(30)
                    cell.longPressGR = UILongPressGestureRecognizer()
                    cell.backgroundColor = .lightGray
                    cell.layer.borderColor = cell.backgroundColor?.cgColor
                    return cell
                }
            default:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presetButtonCell, for: indexPath) as? PresetButtonCell {
                    cell.presetName = presetsList[indexPath.item].presetName
                    cell.delegate = self
                    cell.backgroundColor = colors[indexPath.item]
                    cell.layer.borderColor = cell.backgroundColor?.cgColor
                    return cell
                }
            }
            return PresetButtonCell()
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCell, for: indexPath)
            cell.contentView.addSubview(tutorialLabel)
            cell.contentView.addConstraint(NSLayoutConstraint(item: tutorialLabel, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1, constant: 0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: tutorialLabel, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == presetsList.count {
            let renameController = UIAlertController(title: "Add current position as preset", message: "Give this preset a name", preferredStyle: .alert)
            
            renameController.addTextField(configurationHandler: { (textfield) in
                textfield.placeholder = "Preset Name"
                textfield.text = ""
            })
            renameController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            renameController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.savePreset(withUUID: UUID(),
                                named: renameController.textFields?[0].text ?? "",
                                forDevice: UUID(uuidString: globalDeviceObject.uuid) ?? UUID())
                //self.presetsList.append(renameController.textFields?[0].text ?? "")
                
            }))
            self.present(renameController, animated: true, completion: {
                
            })
            return
        }
        handlePresetButtonPressed(indexPath: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
        dismissSelf()
    }
    
    func handlePresetButtonPressed(indexPath: IndexPath) {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        
        guard (indexPath.section == 1) else { return }
        
        bluetoothTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            (_) in
            if (indexPath.row == 0){
                self.triggerCommand(keycode: keycode.memory1)
            } else if (indexPath.row == 1){
                self.triggerCommand(keycode: keycode.memory2)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: { self.bluetoothTimer!.invalidate() })
    }
    
    func triggerCommand(keycode: keycode) {
        let movement = self.remoteControlConfig.getKeycode(name: keycode)
        bluetooth.connectedPeripheral!.writeValue(movement, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 44)
        case 1:
            return CGSize(width: collectionView.frame.width/2 - 50, height: collectionView.frame.width/4 - 25)
        case 2:
            return CGSize(width: collectionView.frame.width, height: 44)
        case 3:
            return CGSize(width: collectionView.frame.width/2 - 50, height: collectionView.frame.width/4 - 25)
        case 4:
            return CGSize(width: collectionView.frame.width, height: 44)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
            
        case 1:
            let cellWidth : CGFloat = collectionView.frame.width/2 - 50
            let numberOfCells = floor(collectionView.frame.size.width / cellWidth)
            let edgeInsets = (collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            return UIEdgeInsets(top: 15, left: edgeInsets, bottom: 0, right: edgeInsets)
            
        case 3:
            let cellWidth : CGFloat = collectionView.frame.width/2 - 50
            let numberOfCells = floor(collectionView.frame.size.width / cellWidth)
            let edgeInsets = (collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            return UIEdgeInsets(top: 15, left: edgeInsets, bottom: 0, right: edgeInsets)
            
        default:
            return UIEdgeInsets.zero
        }
    }
    
    func presetButtonEditHandler(preset: String, cell: PresetButtonCell) {
        if let index = collectionView.indexPath(for: cell) {
            print(index)
            if index.item == presetsList.count {
                let renameController = UIAlertController(title: "Add current position as preset", message: "Give this preset a name", preferredStyle: .alert)
                
                renameController.addTextField(configurationHandler: { (textfield) in
                    textfield.placeholder = "Preset Name"
                    textfield.text = ""
                })
                renameController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                renameController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.savePreset(withUUID: UUID(),
                                    named: renameController.textFields?[0].text ?? "",
                                    forDevice: UUID(uuidString: globalDeviceObject.uuid) ?? UUID())
                    //self.presetsList.append(renameController.textFields?[0].text ?? "")
                    
                }))
                self.present(renameController, animated: true, completion: {
                    
                })
            } else {
                showEditSheet(title: preset, indexPath: index, cell: cell)
            }
        }
        print("Editing preset \(preset)")
    }
    
    private func showEditSheet(title: String, indexPath: IndexPath, cell: PresetButtonCell) {
        
        let editMenu = UIAlertController(title: title, message: "Choose options for preset \(title)", preferredStyle: .actionSheet)
        editMenu.addAction(UIAlertAction(title: "Save current position", style: .default, handler: { (_) in
            guard self.bluetoothBackgroundHandler.checkStatus() else { return }
            self.characteristic = self.bluetooth.writeCharacteristic
            
            guard (indexPath.section == 1) else { return }
                if (indexPath.row == 0){
                    self.triggerCommand(keycode: keycode.storeMemoryPosition)
                    self.triggerCommand(keycode: keycode.memory1)
                } else if (indexPath.row == 1){
                    self.triggerCommand(keycode: keycode.storeMemoryPosition)
                    self.triggerCommand(keycode: keycode.memory2)
                }
        }))
        guard !(indexPath.section == 1) else {
            editMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(editMenu, animated: true, completion: nil)
            return
        }
        editMenu.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (_) in
            let renameController = UIAlertController(title: "Rename \(title)", message: "Give this preset a name", preferredStyle: .alert)
            
            renameController.addTextField(configurationHandler: { (textfield) in
                textfield.placeholder = "Preset Name"
                textfield.text = title
            })
            renameController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            renameController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.presetsList[indexPath.item].presetName = renameController.textFields?[0].text ?? "ERROR"
                self.updatePresetsName(newName: renameController.textFields?[0].text ?? "ERROR",
                                       uuid: self.presetsList[indexPath.item].presetUUID ?? UUID())
                cell.presetName = renameController.textFields?[0].text
                print("Renaming preset \(title) to \(renameController.textFields?[0].text ?? "ERROR")")
            }))
            self.present(renameController, animated: true, completion: {
                
            })
        }))
        editMenu.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            // Implement deletion of preset from Core Data
            // Remove cell from collectionView
            
            let posOfToDelete = indexPath.item
            self.deletePreset(presetToDelete: self.presetsList[posOfToDelete])
            
        }))
        editMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(editMenu, animated: true, completion: nil)
    }
    
    private func getSavedPresets() {
        let fetchRequest: NSFetchRequest<Preset> = Preset.fetchRequest()
        let predicateUUID = NSPredicate(format: "deviceUUID = %@", globalDeviceObject.uuid)
        fetchRequest.predicate = predicateUUID
        
        do {
            let savedPresets = try PersistenceService.context.fetch(fetchRequest)
            self.presetsList = savedPresets
        } catch {
            print("Couldn't update the data, reload!")
        }
    }
    
    private func savePreset(withUUID: UUID, named: String, forDevice: UUID){
        let preset = Preset(context: PersistenceService.context)
        preset.presetUUID = withUUID
        preset.presetName = named
        preset.deviceUUID = forDevice
        PersistenceService.saveContext()
        self.getSavedPresets()
    }
    
    private func updatePresetsName(newName: String, uuid: UUID) {
        let fetchRequest: NSFetchRequest<Preset> = Preset.fetchRequest()
        
        do {
            let savedDevices = try PersistenceService.context.fetch(fetchRequest)
            for preset in savedDevices {
                if preset.presetUUID == uuid {
                    preset.presetName = newName
                    try PersistenceService.context.save()
                }
            }
            self.getSavedPresets()
        } catch {
            print("Devices couldn't be load")
        }
    }
    
    func deletePreset(presetToDelete: Preset) {
        let fetchRequest: NSFetchRequest<Preset> = Preset.fetchRequest()
        
        do {
            let savedPresets = try PersistenceService.context.fetch(fetchRequest)
            for preset in savedPresets {
                if presetToDelete.presetUUID == preset.presetUUID {
                    PersistenceService.context.delete(preset)
                    try PersistenceService.context.save()
                }
            }
            self.getSavedPresets()
        } catch {
            print("Presets couldn't be loaded")
        }
    }
}

class PresetButtonCell: UICollectionViewCell {
    
    // This has to be changed to a preset object
    var presetName: String? {
        didSet {
            presetNameLabel.text = presetName
        }
    }
    
    var delegate: PresetButtonDelegate?
    
    let presetNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var longPressGR = UILongPressGestureRecognizer()
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? backgroundColor?.withAlphaComponent(0.9) : backgroundColor?.withAlphaComponent(1)
            self.transform = isHighlighted ? CGAffineTransform.init(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(presetNameLabel)
        self.contentView.addConstraint(NSLayoutConstraint(item: presetNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: presetNameLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
        // Setup card appearance
        layer.cornerRadius = 15
        layer.borderWidth = 3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 12.0
        layer.shadowOpacity = 0.7
        
        contentView.isUserInteractionEnabled = true
        
        backgroundColor = UIButton().tintColor
        
        self.longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleEditLongPress(_:)))
        self.longPressGR.minimumPressDuration = 0.8
        contentView.addGestureRecognizer(longPressGR)
    }
    
    @objc
    private func handleEditLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            delegate?.presetButtonEditHandler(preset: presetName ?? "ERROR", cell: self)
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol PresetButtonDelegate {
    func presetButtonEditHandler(preset: String, cell: PresetButtonCell)
}

