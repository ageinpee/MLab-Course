//
//  DetailVendorView.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 13.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailVendorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var displayingVendor: Vendor!
    var displayingAnnotation: MKAnnotationView!
    var vendorAccessories = [Accessory]()
    var fontSize = 22.0
    
    lazy var backgroundAlphaView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = .clear //UIColor.black.withAlphaComponent(0)
        return view
    }()
    let vendorView = UIView()
    var isPresenting = false
    
    var vendorName = UILabel()
    var vendorStreet = UILabel()
    var vendorOpeningHours = UILabel()
    var vendorTelephoneNumber = UILabel()
    
    var collectionView: UICollectionView!
    
    var panGestureForView = UIPanGestureRecognizer()
    var panGestureForMap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(backgroundAlphaView)
        view.addSubview(vendorView)
        
        initializeVendorView()
        initializeVendorInformation()
        
        vendorAccessories = displayingVendor.accessories
        
        let layout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width, height: 100)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height / 2, width: self.view.frame.width, height: 100), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(AccessoryCustomCollectionCell.self, forCellWithReuseIdentifier: "customAccessoryCollectionCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = true
        view.addSubview(collectionView)
        
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeVendorView() {
        vendorView.backgroundColor = .white
        vendorView.translatesAutoresizingMaskIntoConstraints = false
        vendorView.layer.cornerRadius = 8.0
        vendorView.clipsToBounds = true
        vendorView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2).isActive = true
        vendorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vendorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vendorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        panGestureForView = UIPanGestureRecognizer(target: self, action: #selector(DetailVendorViewController.draggedView(_:)))
        vendorView.isUserInteractionEnabled = true
        vendorView.addGestureRecognizer(panGestureForView)
        
        panGestureForMap = UITapGestureRecognizer(target: self, action: #selector(DetailVendorViewController.closeVendorDetail(_:)))
        backgroundAlphaView.isUserInteractionEnabled = true
        backgroundAlphaView.addGestureRecognizer(panGestureForMap)
    }
    
    func initializeVendorInformation() {
        vendorName = UILabel(frame: CGRect(x: 0, y: vendorView.frame.minY, width: self.view.frame.width, height: 22.0))
        vendorName.text = displayingVendor.name
        vendorName.textAlignment = .center
        vendorStreet = UILabel(frame: CGRect(x: 0, y: vendorName.frame.maxY, width: self.view.frame.width, height: 22.0))
        vendorStreet.text = displayingVendor.street
        vendorStreet.textAlignment = .center
        vendorOpeningHours = UILabel(frame: CGRect(x: 0, y: vendorStreet.frame.maxY, width: self.view.frame.width, height: 22.0))
        vendorOpeningHours.text = "\(displayingVendor.openingHour)AM - \(displayingVendor.closingHour)PM"
        vendorOpeningHours.textAlignment = .center
        vendorTelephoneNumber = UILabel(frame: CGRect(x: 0, y: vendorOpeningHours.frame.maxY, width: self.view.frame.width, height: 22.0))
        vendorTelephoneNumber.text = displayingVendor.telephoneNumber
        vendorTelephoneNumber.textAlignment = .center
        
        vendorView.addSubview(vendorName)
        vendorView.addSubview(vendorStreet)
        vendorView.addSubview(vendorOpeningHours)
        vendorView.addSubview(vendorTelephoneNumber)
        
        vendorName.topAnchor.constraint(equalTo: self.vendorView.topAnchor).isActive = true
        vendorStreet.topAnchor.constraint(equalTo: self.vendorName.bottomAnchor).isActive = true
        vendorTelephoneNumber.topAnchor.constraint(equalTo: self.vendorStreet.bottomAnchor).isActive = true
        vendorOpeningHours.topAnchor.constraint(equalTo: self.vendorTelephoneNumber.bottomAnchor).isActive = true
        
    }
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(vendorView)
        let transition = sender.translation(in: self.view)
        let newPosition = CGPoint(x: vendorView.center.x, y: vendorView.center.y + transition.y)
        if draggableViewArea(newPoint: newPosition){
            vendorView.center = newPosition
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    func draggableViewArea(newPoint: CGPoint) -> Bool {
        return newPoint.y >= (self.view.frame.height / 2) + (self.view.frame.height / 4) && newPoint.y <= self.view.frame.height
    }
    
    @objc func closeVendorDetail(_ sender: UIPanGestureRecognizer) {
        displayingAnnotation.isSelected = false
        dismiss(animated: true, completion: nil)
    }
}

extension DetailVendorViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return (self as! UIViewControllerAnimatedTransitioning)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return (self as! UIViewControllerAnimatedTransitioning)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            vendorView.frame.origin.y += self.view.frame.height / 3
            backgroundAlphaView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.vendorView.frame.origin.y -= self.view.frame.height / 3
                self.backgroundAlphaView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.vendorView.frame.origin.y += self.view.frame.height / 3
                self.backgroundAlphaView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
