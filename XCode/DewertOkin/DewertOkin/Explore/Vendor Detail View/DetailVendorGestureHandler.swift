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
        guard runningAnimators.isEmpty else { return }
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.backgroundAlphaView.backgroundColor = .black
                self.backgroundAlphaView.alpha = 0.5
            case .halfOpen:
                self.bottomConstraint.constant = self.vendorViewOffset
                self.backgroundAlphaView.backgroundColor = .clear
                self.backgroundAlphaView.alpha = 0.1
            }
            self.view.layoutIfNeeded() //vendorView?
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
                self.bottomConstraint.constant = self.vendorViewOffset
            }
            self.runningAnimators.removeAll()
        }
        transitionAnimator.startAnimation()
        
        runningAnimators.append(transitionAnimator)
    }
    
    @objc func vendorDetailViewGesture(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
            
        case .began:
            animateVendorDetailView(to: currentState.opposite, duration: 1)
            runningAnimators.forEach { $0.pauseAnimation() }
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            let translation = recognizer.translation(in: vendorView)
            var fraction = -translation.y / self.vendorViewOffset
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= 1 }
            
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            let yVelocity = recognizer.velocity(in: vendorView).y
            let shouldClose = yVelocity > 0
            
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .halfOpen:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
    @objc func closeVendorDetail(_ sender: UIPanGestureRecognizer) {
        self.backgroundAlphaView.alpha = 0
        backgroundAlphaView.removeFromSuperview()
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

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
}
