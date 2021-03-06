//
//  ExtraFunctionsController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class ExtraFunctionsController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var moreFunctionsLabel: UILabel!
    @IBOutlet var globalView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tapView: UIView!
    
    var functionsList: [String] = [String]()
    var totalHeight: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        functionsList = ["Massage", "UBL", "Torch", "Massage2"]
        
        createButtons(withText: functionsList)
        createViews()
        
    }
    
    @objc func functionsButtonAction(sender: UIButton!) {
        sender.backgroundColor = UIColor.lightGray
        sender.alpha = 0.5
        switch sender.tag {
        case 0:
            print("xxx")
        case 1:
            print("yyy")
        case 2:
            print("zzz")
        case 3:
            print("aaa")
        case 4:
            print("bbb")
        case 5:
            print("ccc")
        default:
            print("default")
        }
    }
    
    @objc func functionsButtonActionEnd(sender: UIButton!) {
        sender.backgroundColor = UIColor.white
        sender.alpha = 1
        switch sender.tag {
        case 0:
            print("xxxx")
        case 1:
            print("xyyy")
        case 2:
            print("xzzz")
        case 3:
            print("xaaa")
        case 4:
            print("xbbb")
        case 5:
            print("xccc")
        default:
            print("default")
        }
    }
    
}

class ExtraFeaturesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let featureList: [String] = ["Massage", "UBL", "Torch", "Massage2"]
    
    let reuseIdentifier = "defaultCell"
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your device has these additional features"
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
        navigationItem.title = "Extra Features"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
        
        collectionView.alwaysBounceVertical = true
    }
    
    @objc
    private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featureList.count + 1
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
            let buttonTitle = featureList[indexPath.row - 1]
            let newButton = createFeatureButton(buttonTitle: buttonTitle)
            cell.addSubview(newButton)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0" : newButton]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : newButton]))
            cell.addConstraint(NSLayoutConstraint(item: newButton, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        }
        
        //cell.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        return cell
    }
    
    private func createFeatureButton(buttonTitle: String) -> UIButton {
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
