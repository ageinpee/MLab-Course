//
//  DetailVendorGestureHandler.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 17.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension DetailVendorViewController {
    
    func animateVendorDetailView(to state: State, duration: TimeInterval) {
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
            case .halfOpen:
                self.bottomConstraint.constant = self.view.frame.height / 2
            }
            self.vendorView.layoutIfNeeded()
        })
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .halfOpen:
                self.bottomConstraint.constant = self.view.frame.height / 2
            }
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func vendorDetailViewGesture(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateVendorDetailView(to: currentState.opposite, duration: 1.5)
            transitionAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: vendorView)
            var fraction = -translation.y / popupOffset
            if currentState == .open { fraction *= -1 }
            transitionAnimator.fractionComplete = fraction
        case .ended:
            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
    
    @objc func closeVendorDetail(_ sender: UIPanGestureRecognizer) {
        displayingAnnotation.isSelected = false
        isPresenting = !isPresenting
        dismiss(animated: true, completion: nil)
    }
    
}

enum State {
    case halfOpen
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .halfOpen
        case .halfOpen: return .open
        }
    }
}
