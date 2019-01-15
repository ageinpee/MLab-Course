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

class DetailVendorViewController: UIViewController {
    
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
    
    var panGestureForView = UIPanGestureRecognizer()
    var panGestureForMap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(backgroundAlphaView)
        view.addSubview(vendorView)
        initializeVendorInformation()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeVendorInformation() {
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
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(vendorView)
        let transition = sender.translation(in: self.view)
        //guard (vendorView.center.y <= self.view.frame.height / 2) && transition.y > 0 else { return }
        vendorView.center = CGPoint(x: vendorView.center.x, y: vendorView.center.y + transition.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
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
