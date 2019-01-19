//
//  DetailVendorView.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 13.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass
import MapKit

extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func initializeVendorView() {
        
        backgroundAlphaView.translatesAutoresizingMaskIntoConstraints = false
        UIApplication.shared.keyWindow?.addSubview(backgroundAlphaView)
        backgroundAlphaView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backgroundAlphaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        backgroundAlphaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backgroundAlphaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        vendorView.backgroundColor = .white
        vendorView.translatesAutoresizingMaskIntoConstraints = false
        vendorView.layer.cornerRadius = 20.0
        vendorView.clipsToBounds = true
        vendorView.layer.shadowColor = UIColor.black.cgColor
        vendorView.layer.shadowOpacity = 0.1
        vendorView.layer.shadowRadius = 10
        vendorView.isUserInteractionEnabled = true
        UIApplication.shared.keyWindow?.addSubview(vendorView)
        vendorView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2).isActive = true
        vendorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vendorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        vendorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vendorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomConstraint = vendorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: vendorViewOffset)
        bottomConstraint.isActive = true
        
        closeButton.frame = CGRect(x: self.view.frame.width - 60, y: 20, width: 50, height: 50)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16)
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.layer.backgroundColor = UIColor.gray.cgColor
        closeButton.layer.borderWidth = 1
        closeButton.layer.cornerRadius = 25
        closeButton.isUserInteractionEnabled = true
        closeButton.addTarget(self, action: #selector(touchedCloseButton(sender:)), for: .touchUpInside)
        vendorView.addSubview(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.rightAnchor.constraint(equalTo: vendorView.rightAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: vendorView.topAnchor).isActive = true
        
        let panTapAnimation = InstantPanGestureRecognizer()
        panTapAnimation.addTarget(self, action: #selector(ExploreViewController.vendorDetailViewGesture(recognizer:)))
        vendorView.addGestureRecognizer(panTapAnimation)
    }
    
    func initializeVendorInformation() {
        vendorName = UILabel(frame: CGRect(x: 0, y: vendorView.frame.minY + 22, width: self.view.frame.width, height: 22.0))
        vendorName.text = displayingVendor.name
        vendorName.textAlignment = .left
        vendorName.font = UIFont(name: "ArialMT", size: 22.0)
        vendorStreet = UILabel(frame: CGRect(x: 0, y: vendorName.frame.maxY, width: self.view.frame.width, height: 16.0))
        vendorStreet.text = displayingVendor.street
        vendorStreet.textAlignment = .left
        vendorStreet.font = UIFont(name: "ArialMT", size: 16.0)
        vendorOpeningHours = UILabel(frame: CGRect(x: 0, y: vendorStreet.frame.maxY, width: self.view.frame.width, height: 16.0))
        vendorOpeningHours.text = "\(displayingVendor.openingHour)AM - \(displayingVendor.closingHour)PM"
        vendorOpeningHours.textAlignment = .left
        vendorOpeningHours.font = UIFont(name: "ArialMT", size: 16.0)
        vendorTelephoneNumber = UILabel(frame: CGRect(x: 0, y: vendorOpeningHours.frame.maxY, width: self.view.frame.width, height: 16.0))
        vendorTelephoneNumber.text = displayingVendor.telephoneNumber
        vendorTelephoneNumber.textAlignment = .left
        vendorTelephoneNumber.font = UIFont(name: "ArialMT", size: 16.0)
        
        vendorView.addSubview(vendorName)
        vendorView.addSubview(vendorStreet)
        vendorView.addSubview(vendorOpeningHours)
        vendorView.addSubview(vendorTelephoneNumber)
        
        vendorName.topAnchor.constraint(equalTo: self.vendorView.topAnchor).isActive = true
        vendorStreet.topAnchor.constraint(equalTo: self.vendorName.bottomAnchor).isActive = true
        vendorTelephoneNumber.topAnchor.constraint(equalTo: self.vendorStreet.bottomAnchor).isActive = true
        vendorOpeningHours.topAnchor.constraint(equalTo: self.vendorTelephoneNumber.bottomAnchor).isActive = true
        
    }
    
    func initializeAccessoryCollection() {
        vendorAccessories = displayingVendor.accessories
        
        let layout = UICollectionViewFlowLayout()
        _ = CGFloat(self.vendorView.frame.width) * CGFloat(vendorAccessories.count)
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: (vendorViewOffset * 2) - 200, width: self.view.frame.width, height: 150), collectionViewLayout: layout)
        //collectionView.contentSize = CGSize(width: width, height: 150)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(AccessoryCustomCollectionCell.self, forCellWithReuseIdentifier: "customAccessoryCollectionCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.bounces = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.isScrollEnabled = true
        collectionView.isUserInteractionEnabled = true
        vendorView.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: vendorView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: vendorView.trailingAnchor).isActive = true
    }
    
}
