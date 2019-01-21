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
        //backgroundAlphaView.addTarget(self, action: #selector(touchedCloseButton(sender:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(backgroundAlphaView)
        backgroundAlphaView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backgroundAlphaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        backgroundAlphaView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        backgroundAlphaView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
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
        
        let panTapAnimation = InstantPanGestureRecognizer()
        panTapAnimation.addTarget(self, action: #selector(ExploreViewController.vendorDetailViewGesture(recognizer:)))
        panTapAnimation.cancelsTouchesInView = false
        panTapAnimation.delegate = self
        vendorView.addGestureRecognizer(panTapAnimation)
        
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16)
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.layer.backgroundColor = UIColor.gray.cgColor
        closeButton.layer.borderWidth = 1
        closeButton.layer.cornerRadius = 25
        closeButton.titleLabel?.isUserInteractionEnabled = true
        closeButton.isUserInteractionEnabled = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(touchedCloseButton(sender:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.rightAnchor.constraint(equalTo: vendorView.rightAnchor, constant: -20).isActive = true
        closeButton.topAnchor.constraint(equalTo: vendorView.topAnchor, constant: 20).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: vendorView.topAnchor, constant: 70).isActive = true
    }
    
    func initializeVendorInformation() {
        
        vendorName.text = displayingVendor.name
        vendorName.textAlignment = .left
        vendorName.isUserInteractionEnabled = true
        vendorName.font = UIFont(name: "ArialMT", size: 20.0)
        vendorName.translatesAutoresizingMaskIntoConstraints = false
        
        vendorStreet.text = displayingVendor.street
        vendorStreet.textAlignment = .left
        vendorStreet.isUserInteractionEnabled = true
        vendorStreet.font = UIFont(name: "ArialMT", size: 16.0)
        vendorStreet.translatesAutoresizingMaskIntoConstraints = false
        
        vendorView.addSubview(vendorName)
        vendorView.addSubview(vendorStreet)
        
        vendorName.topAnchor.constraint(equalTo: self.vendorView.topAnchor, constant: 10).isActive = true
        vendorName.leftAnchor.constraint(equalTo: self.vendorView.leftAnchor, constant: 10).isActive = true
        vendorStreet.topAnchor.constraint(equalTo: self.vendorName.bottomAnchor).isActive = true
        vendorStreet.leftAnchor.constraint(equalTo: self.vendorView.leftAnchor, constant: 10).isActive = true
    }
    
    func initializeVendorWebsite() {
        
        vendorWebsite = UIButton.init(type: .custom)
        vendorWebsite.setTitle("Onlineshop", for: .normal)
        vendorWebsite.layer.backgroundColor = UIColor.blue.cgColor
        vendorWebsite.layer.borderWidth = 0
        vendorWebsite.layer.cornerRadius = 25
        vendorWebsite.translatesAutoresizingMaskIntoConstraints = false
        UIApplication.shared.keyWindow?.addSubview(vendorWebsite)
        
        vendorWebsite.heightAnchor.constraint(equalToConstant: 50).isActive = true
        vendorWebsite.widthAnchor.constraint(equalTo: vendorView.widthAnchor, constant: -40).isActive = true
        vendorWebsite.leftAnchor.constraint(equalTo: vendorView.leftAnchor, constant: 20).isActive = true
        vendorWebsite.rightAnchor.constraint(equalTo: vendorView.rightAnchor, constant: -20).isActive = true
        vendorWebsite.bottomAnchor.constraint(equalTo: vendorView.bottomAnchor, constant: -70).isActive = true
    }
    
    func initializeAccessoryCollection() {
        vendorAccessories = displayingVendor.accessories
        
        collectionViewName.text = "Compatible Accessories:"
        collectionViewName.textAlignment = .left
        collectionViewName.isUserInteractionEnabled = true
        collectionViewName.font = UIFont(name: "ArialMT", size: 20)
        collectionViewName.translatesAutoresizingMaskIntoConstraints = false
        vendorView.addSubview(collectionViewName)
        
        collectionViewName.topAnchor.constraint(equalTo: self.vendorStreet.bottomAnchor, constant: 20).isActive = true
        collectionViewName.leftAnchor.constraint(equalTo: self.vendorView.leftAnchor, constant: 10).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: collectionViewName.frame.maxY, width: self.view.frame.width, height: 100), collectionViewLayout: layout)
        collectionView.contentSize = CGSize(width: 100, height: 100)
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        UIApplication.shared.keyWindow?.addSubview(collectionView)
        
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: vendorView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: vendorView.trailingAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: vendorView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: vendorView.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: collectionViewName.bottomAnchor).isActive = true
    }
    
}
