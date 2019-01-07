//
//  pullUpSegue.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class pullUpSegue: UIStoryboardSegue {
    
    override func perform() {
        animateSegue()
    }
    
    func animateSegue() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let offset = toViewController.view.bounds.height
        let containerView = fromViewController.view.superview
        
        //adding views
        containerView?.addSubview(toViewController.view)
        
        toViewController.view.insertSubview(fromViewController.view, at: -1)
        toViewController.view.transform = CGAffineTransform(translationX:0, y: offset)
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .allowUserInteraction, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }) { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        }
    }
}

class pullUpUnwindSegue: UIStoryboardSegue {
    override func perform() {
        animateUnwindSegue()
    }
    
    func animateUnwindSegue() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let offset = toViewController.view.bounds.height
        let containerView = fromViewController.view.superview
        
        //adding views
        containerView?.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       options: .allowUserInteraction,
                       animations: { fromViewController.view.transform = CGAffineTransform(translationX: 0, y: offset) })
                        { success in fromViewController.present(toViewController, animated: false, completion: nil) }
    }
}
