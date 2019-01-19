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

class DetailVendorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Data from ExploreMapViewController
    var displayingVendor: Vendor!
    var displayingAnnotation: MKAnnotationView!
    var vendorAccessories = [Accessory]()
    
    // UI Elements
    lazy var backgroundAlphaView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = .clear
        view.alpha = 0.1
        return view
    }()
    var closeButton = UIButton()
    let vendorView = UIView()
    var isPresenting = false
    var currentState: State = .halfOpen
    var bottomConstraint = NSLayoutConstraint()
    
    var vendorName = UILabel()
    var vendorStreet = UILabel()
    var vendorOpeningHours = UILabel()
    var vendorTelephoneNumber = UILabel()
    
    var collectionView: UICollectionView!
    
    // Gesture Recognizer & Animation Elements
    var panGestureForView = UIPanGestureRecognizer()
    var panGestureForMap = UITapGestureRecognizer()
    var panTapAnimation = InstantPanGestureRecognizer()
    var animationProgress = [CGFloat]()
    var runningAnimators = [UIViewPropertyAnimator]()
    var vendorViewOffset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vendorViewOffset = self.view.frame.height / 4
        view.backgroundColor = .clear
        
        initializeVendorView()
        initializeVendorInformation()
        initializeAccessoryCollection()
        
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
        
        backgroundAlphaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundAlphaView)
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
        view.addSubview(vendorView)
        vendorView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2).isActive = true
        vendorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vendorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        vendorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vendorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomConstraint = vendorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: vendorViewOffset)
        bottomConstraint.isActive = true
        
        closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: self.view.frame.width - 50, y: 10, width: 40, height: 40)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16)
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.layer.backgroundColor = UIColor.gray.cgColor
        closeButton.layer.borderWidth = 1
        closeButton.layer.cornerRadius = 20
        vendorView.addSubview(closeButton)
        
        panTapAnimation = InstantPanGestureRecognizer()
        panTapAnimation.addTarget(self, action: #selector(DetailVendorViewController.vendorDetailViewGesture(recognizer:)))
        vendorView.isUserInteractionEnabled = true
        vendorView.addGestureRecognizer(panTapAnimation)
        
        panGestureForMap = UITapGestureRecognizer(target: self, action: #selector(DetailVendorViewController.closeVendorDetail(_:)))
        backgroundAlphaView.isUserInteractionEnabled = true
        backgroundAlphaView.addGestureRecognizer(panGestureForMap)
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
        var width = CGFloat(self.vendorView.frame.width) * CGFloat(vendorAccessories.count)
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
        collectionView.layoutIfNeeded()
        collectionView.layoutSubviews()
        collectionView.leadingAnchor.constraint(equalTo: vendorView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: vendorView.trailingAnchor).isActive = true
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
            
            vendorView.frame.origin.y += self.vendorViewOffset
            backgroundAlphaView.alpha = 0
            
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
                self.vendorView.frame.origin.y -= self.vendorViewOffset
                self.backgroundAlphaView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
                self.vendorView.frame.origin.y += self.vendorViewOffset
                self.backgroundAlphaView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
