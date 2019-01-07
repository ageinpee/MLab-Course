//
//  PresetsController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class PresetsController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addPresetButton: UIButton!
    @IBOutlet weak var choosePresetLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    var presetsList: [String] = [String]()
    var presetsData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presetsList = []//["sleeping", "mornings", "relaxing"]
        
        checkPresetsList()
        
        setupAddButton()
        createButtons(withText: presetsList)
    }
    
    @IBAction func unwindFromAddPreset(_ sender: UIStoryboardSegue) {
        if sender.source is AddPresetController {
            if let senderVC = sender.source as? AddPresetController {
                presetsData = senderVC.data
                presetsList.append(presetsData[0])
            }
            checkPresetsList()
            createButtons(withText: presetsList)
        }
    }
    
    func checkPresetsList() {
        if presetsList.count != 0 {
            textLabel.isHidden = true
        } else {
            choosePresetLabel.isHidden = true
        }
    }
    
    func setupAddButton () {
        let width = addPresetButton.frame.width
        addPresetButton.layer.cornerRadius = width/2
        addPresetButton.layer.masksToBounds = true
        addPresetButton.layer.borderWidth = 2
        addPresetButton.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
    }
    
    @objc func functionsButtonAction(sender: UIButton!) {
        switch sender.tag {
        case 0:
            print("xxx")
            sender.backgroundColor = UIColor.lightGray
        case 1:
            print("yyy")
            sender.backgroundColor = UIColor.lightGray
        case 2:
            print("zzz")
            sender.backgroundColor = UIColor.lightGray
        default:
            print("default")
        }
    }
    
    @objc func functionsButtonActionEnd(sender: UIButton!) {
        switch sender.tag {
        case 0:
            sender.backgroundColor = UIColor.white
        case 1:
            sender.backgroundColor = UIColor.white
        case 2:
            sender.backgroundColor = UIColor.white
        default:
            print("default")
        }
    }
}

class SelectPresetViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let presetsList: [String] = ["Sleeping", "Reading", "Relaxing"]
    
    let reuseIdentifier = "defaultCell"
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Select the preset you want to edit"
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    @objc
    private func test() {
        print("Success")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Select Preset"
        
        collectionView.alwaysBounceVertical = true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetsList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if indexPath.row == 0 {
            cell.addSubview(descriptionLabel)
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : descriptionLabel]))
            cell.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        } else {
            let buttonTitle = presetsList[indexPath.row - 1]
            let newButton = createPresetButton(buttonTitle: buttonTitle)
            cell.addSubview(newButton)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : newButton]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : newButton]))
            cell.addConstraint(NSLayoutConstraint(item: newButton, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        }
        
        //cell.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        return cell
    }
    
    private func createPresetButton(buttonTitle: String) -> UIButton {
        let button = UIButton()
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = collectionView.tintColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: button.contentEdgeInsets.top + 5, left: button.contentEdgeInsets.left + 5, bottom: button.contentEdgeInsets.bottom + 5, right: button.contentEdgeInsets.right + 5)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
        return button
    }
}
