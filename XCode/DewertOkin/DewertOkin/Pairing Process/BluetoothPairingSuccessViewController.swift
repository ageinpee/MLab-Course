//
//  BluetoothPairingSuccessViewController.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 20.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit
import CoreGraphics

class BluetoothPairingSuccessViewController: UIViewController {
    
    let circleLayer = CAShapeLayer()
    let successLayer = CAShapeLayer()
    var animating: Bool = true
    
    let strokeEndAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    let strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 4
        animation.repeatCount = MAXFLOAT
        return animation
    }()
    
    let successStrokeAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawCircle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.animating = false
            self.updateAnimation()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func drawCircle() {
        circleLayer.lineWidth = 4
        circleLayer.fillColor = nil
        circleLayer.strokeColor = UIColor.blue.cgColor
        
        let center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        let radius = min(self.view.frame.width - 100, self.view.frame.height) / 2 - circleLayer.lineWidth/2
        let startAngle = CGFloat(-(Double.pi / 2))
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circleLayer.position = center
        circleLayer.path = path.cgPath
        
        view.layer.addSublayer(circleLayer)
    }
    
    func successCircle() {
        successLayer.fillColor = UIColor.green.cgColor
        successLayer.strokeColor = UIColor.green.cgColor
        successLayer.lineWidth = 4
        
        let center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        let radius = min(self.view.frame.width - 100, self.view.frame.height) / 2 - circleLayer.lineWidth/2
        let startAngle = CGFloat(-(Double.pi / 2))
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        successLayer.position = center
        successLayer.path = path.cgPath
        
        view.layer.addSublayer(successLayer)
    }
    
    func updateAnimation() {
        if animating {
            circleLayer.add(strokeEndAnimation, forKey: "strokeEnd")
            circleLayer.add(strokeStartAnimation, forKey: "strokeStart")
            circleLayer.add(rotationAnimation, forKey: "rotation")

        } else {
            circleLayer.removeAnimation(forKey: "strokeEnd")
            circleLayer.removeAnimation(forKey: "strokeStart")
            circleLayer.removeAnimation(forKey: "rotation")
            circleLayer.strokeColor = UIColor.green.cgColor
            circleLayer.add(successStrokeAnimation, forKey: "strokeEnd")
        }
    }
    
    func showRemote() {
        let remoteController = RemoteController()
        self.navigationController?.pushViewController(remoteController, animated: true)
    }
    
}

