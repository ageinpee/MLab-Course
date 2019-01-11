//
//  RemoteControllerExtension.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension RemoteController {
    
    func setupPanAreas() {
        leftPanArea.isUserInteractionEnabled = true
        rightPanArea.isUserInteractionEnabled = true
        
        let selectorRight = #selector(handleRightPanGesture(panRecognizer:))
        let selectorLeft = #selector(handleLeftPanGesture(panRecognizer:))
        
        panRecLeft = UIPanGestureRecognizer(target: self, action: selectorLeft)
        panRecRight = UIPanGestureRecognizer(target: self, action: selectorRight)
        
        leftPanArea.addGestureRecognizer(panRecLeft)
        rightPanArea.addGestureRecognizer(panRecRight)
        
        panRecLeft.delegate = self
        panRecRight.delegate = self
        
        leftPanArea.backgroundColor = UIColor.clear
        rightPanArea.backgroundColor = UIColor.clear
    }
    
    func setupButtons() {
        var width = PresetsButtonObj.frame.width
        PresetsButtonObj.layer.cornerRadius = width/2
        PresetsButtonObj.layer.masksToBounds = true
        PresetsButtonObj.layer.borderWidth = 1
        PresetsButtonObj.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
        PresetsButtonObj.addTarget(self, action: #selector(showPresetsView), for: .touchUpInside)
        
        
        width = TimerButtonObj.frame.width
        TimerButtonObj.layer.cornerRadius = width/2
        TimerButtonObj.layer.masksToBounds = true
        TimerButtonObj.layer.borderWidth = 1
        TimerButtonObj.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
        TimerButtonObj.addTarget(self, action: #selector(pushTimerViewController), for: .touchUpInside)
        
        width = ExtraFunctionsButtonObj.frame.width
        ExtraFunctionsButtonObj.layer.cornerRadius = width/2
        ExtraFunctionsButtonObj.layer.masksToBounds = true
        ExtraFunctionsButtonObj.layer.borderWidth = 1
        ExtraFunctionsButtonObj.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
    }
    
    @objc
    private func showPresetsView() {
        
        backgroundLayer.alpha = 0
        presetsCollectionView.alpha = 0

        UIApplication.shared.keyWindow?.addSubview(self.backgroundLayer)
        self.backgroundLayer.addSubview(self.presetsCollectionView)

        self.backgroundLayer.addConstraint(NSLayoutConstraint.init(item: self.presetsCollectionView, attribute: .centerX, relatedBy: .equal, toItem: self.backgroundLayer, attribute: .centerX, multiplier: 1, constant: 0))
        self.backgroundLayer.addConstraint(NSLayoutConstraint.init(item: self.presetsCollectionView, attribute: .centerY, relatedBy: .equal, toItem: self.backgroundLayer, attribute: .centerY, multiplier: 1, constant: 0))
        self.backgroundLayer.addConstraint(NSLayoutConstraint.init(item: self.presetsCollectionView, attribute: .leading, relatedBy: .equal, toItem: self.backgroundLayer, attribute: .leading, multiplier: 1, constant: 16))
        self.backgroundLayer.addConstraint(NSLayoutConstraint.init(item: self.presetsCollectionView, attribute: .trailing, relatedBy: .equal, toItem: self.backgroundLayer, attribute: .trailing, multiplier: 1, constant: -16))
        self.presetsCollectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.5).isActive = true

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.backgroundLayer.alpha = 1
            self.presetsCollectionView.alpha = 1
        }) { (_) in

                }
        
//        UIApplication.shared.keyWindow?.addSubview(effectsView)
//        presetsCollectionView.alpha = 0
//        effectsView.contentView.addSubview(presetsCollectionView)
//
//        effectsView.contentView.addConstraint(NSLayoutConstraint.init(item: self.presetsCollectionView, attribute: .centerX, relatedBy: .equal, toItem: effectsView.contentView, attribute: .centerX, multiplier: 1, constant: 0))
//        effectsView.contentView.addConstraint(NSLayoutConstraint.init(item: self.presetsCollectionView, attribute: .centerY, relatedBy: .equal, toItem: effectsView.contentView, attribute: .centerY, multiplier: 1, constant: 0))
//        effectsView.contentView.addConstraint(NSLayoutConstraint.init(item: self.presetsCollectionView, attribute: .leading, relatedBy: .equal, toItem: effectsView.contentView, attribute: .leading, multiplier: 1, constant: 16))
//        effectsView.contentView.addConstraint(NSLayoutConstraint.init(item: self.presetsCollectionView, attribute: .trailing, relatedBy: .equal, toItem: effectsView.contentView, attribute: .trailing, multiplier: 1, constant: -16))
//        effectsView.contentView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.5).isActive = true
//
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.presetsCollectionView.alpha = 1
//        }) { (_) in
//
//        }
//
        
    }
    
    @objc
    private func pushTimerViewController() {
        present(UINavigationController(rootViewController: NewTimerListTableViewController()), animated: true, completion: nil)
    }
    
    @objc
    func actionLeft() {
        if (recognizerState == .began) || (recognizerState == .changed) {
            print(Date())
            if translation == .down {
                print("--> down")
            }
            else if translation == .up {
                print("--> up")
            }
        } else {
            print("end")
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc
    func actionRight() {
        if (recognizerState == .began) || (recognizerState == .changed) {
            print(Date())
            if translation == .down {
                print("--> down")
                goDown()
            }
            else if translation == .up {
                print("--> up")
                goUp()
            }
        } else {
            print("end")
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc
    func handleRightPanGesture(panRecognizer: UIPanGestureRecognizer) {
        recognizerState = panRecognizer.state
        
        switch panRecognizer.state {
        case .began:
            print("Pan in Right Area started")
            translation = .began
            timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(actionRight), userInfo: nil, repeats: true)
            
        case .changed:
            if(panRecognizer.translation(in: rightPanArea).y >= 40) {
                translation = .down
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[3]
                
            } else if (panRecognizer.translation(in: rightPanArea).y <= -40) {
                translation = .up
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[2]
                goUp()
            }
        case .ended:
            print("Pan in Right Area ended")
            print(Date())
            translation = .ended
            Image.image = currentStyle.stylesImages[1]
            animateFade(withAlpha: opacity)
        default: break
        }
    }
    
    
    @objc
    func handleLeftPanGesture(panRecognizer: UIPanGestureRecognizer) {
        recognizerState = panRecognizer.state
        
        switch panRecognizer.state {
        case .began:
            print("Pan in Left Area")
            translation = .began
            timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(actionLeft), userInfo: nil, repeats: true)
        case .changed:
            if(panRecognizer.translation(in: leftPanArea).y >= 40) {
                translation = .down
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[5]
                
            } else if (panRecognizer.translation(in: leftPanArea).y <= -40) {
                translation = .up
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[4]
                
            }
        case .ended:
            print("Pan in Left Area ended")
            translation = .ended
            Image.image = currentStyle.stylesImages[1]
            animateFade(withAlpha: opacity)
        default: break
        }
    }
    
    func animateFade(withAlpha: CGFloat) {
        UIView.animate(withDuration: 2.0, delay: 5.0, options: [], animations: {
            self.arrowsImageView.alpha = withAlpha
        }, completion: nil)
    }
}

extension RemoteController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            break
        }
        
        return presetsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCell, for: indexPath)
            cell.contentView.addSubview(memoryDescriptionLabel)
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : memoryDescriptionLabel]))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : memoryDescriptionLabel]))
            return cell
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presetButtonCell, for: indexPath) as? PresetButtonCell {
                cell.presetNameLabel.text = presetsNames[indexPath.item]
                return cell
            }
            return PresetButtonCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 44)
        default:
            return CGSize(width: collectionView.frame.width/2 - 50, height: collectionView.frame.width/2 - 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            let cellWidth : CGFloat = 165.0
            
            let numberOfCells = floor(collectionView.frame.size.width / cellWidth)
            let edgeInsets = (collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            
            return UIEdgeInsets(top: 15, left: edgeInsets, bottom: 0, right: edgeInsets)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Preset \(indexPath.item)")
        
        // REMOVE
        handleBackgroundTap()
    }
    
}

class PresetButtonCell: UICollectionViewCell {
    
    var presetNameLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(presetNameLabel)
        self.contentView.addConstraint(NSLayoutConstraint(item: presetNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: presetNameLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        layer.cornerRadius = 15
        layer.borderWidth = 3
        layer.borderColor = UIButton().tintColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
