//
//  rotationTransition.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 27.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class rotationTransition: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
    
    override func perform() {
        rotate()
    }
    
    func rotate() {
        let toViewController = self.destination
        let fromViewController = self.source
        let backgroundView = UIView()
        
        backgroundView.layer.bounds = fromViewController.view.layer.bounds
        backgroundView.backgroundColor = UIColor.white
        
        let containerView = fromViewController.view.superview
        
        let rotationPoint = CGPoint(x:0.5, y:(1307/896))
        let positionPoint = CGPoint(x:207, y:1307)
        
        //adding views
        containerView?.insertSubview(backgroundView, at: 0)
        containerView?.insertSubview(toViewController.view, at: 2)
        
        //setup for rotation
        backgroundView.layer.anchorPoint = rotationPoint
        backgroundView.layer.position = positionPoint
        fromViewController.view.layer.anchorPoint = rotationPoint
        fromViewController.view.layer.position = positionPoint
        toViewController.view.layer.anchorPoint = rotationPoint
        toViewController.view.layer.position = positionPoint
        toViewController.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        UIView.animate(withDuration: 2.0, delay: 0, options: .allowUserInteraction, animations: {
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        }) { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        }
    }
}
