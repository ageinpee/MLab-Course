//
//  NewPresetsController.swift
//  DewertOkin
//
//  Created by Jan Robert on 13.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import UIKit

class PresetsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PresetButtonDelegate {
    
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
    
    let defaultCell = "defaultCell"
    let presetButtonCell = "presetButtonCell"
    
    let controlUnitPresets = ["Memory 1", "Memory 2"]
    let phonePresetsNames = ["Sleeping", "Relaxing", "Flat"]
    
    let colors: [UIColor] = [ #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), .gray]
    
    override func viewDidLoad() {
        collectionView.register(PresetButtonCell.self, forCellWithReuseIdentifier: presetButtonCell)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultCell)
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        self.navigationItem.title = "Memory"
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf)), animated: false)
        
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
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return controlUnitPresets.count
        case 2:
            return 1
        case 3:
            return phonePresetsNames.count + 1
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
                cell.preset = controlUnitPresets[indexPath.item]
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
            case phonePresetsNames.count:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presetButtonCell, for: indexPath) as? PresetButtonCell {
                    cell.preset = "New Preset"
                    cell.delegate = self
                    cell.presetNameLabel.text = "+"
                    cell.presetNameLabel.font = UIFont.preferredFont(forTextStyle: .headline).withSize(30)
                    cell.backgroundColor = .lightGray
                    cell.layer.borderColor = cell.backgroundColor?.cgColor
                    return cell
                }
            default:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presetButtonCell, for: indexPath) as? PresetButtonCell {
                    cell.preset = phonePresetsNames[indexPath.item]
                    cell.delegate = self
                    cell.backgroundColor = colors[indexPath.item]
                    cell.layer.borderColor = cell.backgroundColor?.cgColor
                    return cell
                }
            }
            return PresetButtonCell()
        default:
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 44)
        case 1:
            return CGSize(width: collectionView.frame.width/2 - 50, height: collectionView.frame.width/2 - 50)
        case 2:
            return CGSize(width: collectionView.frame.width, height: 44)
        case 3:
            return CGSize(width: collectionView.frame.width/2 - 50, height: collectionView.frame.width/2 - 50)
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
    
    func presetButtonEditHandler(preset: String) {
        print("Editing preset \(preset)")
    }
    
}

class PresetButtonCell: UICollectionViewCell {
    
    // This has to be changed to a preset object
    var preset: String? {
        didSet {
            presetNameLabel.text = preset
        }
    }
    
    var delegate: PresetButtonDelegate?
    
    let presetNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(presetNameLabel)
        self.contentView.addConstraint(NSLayoutConstraint(item: presetNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: presetNameLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
        layer.cornerRadius = 15
        layer.borderWidth = 3
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 12.0
        layer.shadowOpacity = 0.7
        
        contentView.isUserInteractionEnabled = true
        
        backgroundColor = UIButton().tintColor
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleEditLongPress(_:)))
        
        contentView.addGestureRecognizer(longPressGR)
    }
    
    @objc
    private func handleEditLongPress(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            delegate?.presetButtonEditHandler(preset: preset ?? "ERROR")
            print("Began")
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol PresetButtonDelegate {
    func presetButtonEditHandler(preset: String)
}

