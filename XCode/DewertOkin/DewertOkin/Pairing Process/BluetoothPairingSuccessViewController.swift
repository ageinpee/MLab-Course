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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.animating = false
            self.updateAnimation()
        })
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
    
    func updateAnimation() {
        if animating {
            circleLayer.add(strokeEndAnimation, forKey: "strokeEnd")
            circleLayer.add(strokeStartAnimation, forKey: "strokeStart")
            circleLayer.add(rotationAnimation, forKey: "rotation")

        } else {
            circleLayer.removeAnimation(forKey: "strokeEnd")
            circleLayer.removeAnimation(forKey: "strokeStart")
            circleLayer.removeAnimation(forKey: "rotation")
            successAnimation()
        }
    }
    
    func successAnimation() {
        circleLayer.strokeColor = UIColor.green.cgColor
        let success = UILabel(frame: CGRect.init(x: circleLayer.position.x, y: circleLayer.position.y, width: 100, height: 100))
        success.textAlignment = NSTextAlignment.center
        success.center = circleLayer.position
        success.text = "Success"
        success.textColor = UIColor.green
        success.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(success)
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            print("Success animation did end")
            self.showRemote()
        }
        circleLayer.add(successStrokeAnimation, forKey: "strokeEnd")
        CATransaction.commit()
    }
    
    func failureAnimation() {
        circleLayer.strokeColor = UIColor.red.cgColor
        let failure = UILabel(frame: CGRect.init(x: circleLayer.position.x, y: circleLayer.position.y, width: 100, height: 100))
        failure.textAlignment = NSTextAlignment.center
        failure.center = circleLayer.position
        failure.text = "Failed"
        failure.textColor = UIColor.green
        failure.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(failure)
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            print("Success animation did end")
            self.showPairingProcess()
        }
        circleLayer.add(successStrokeAnimation, forKey: "strokeEnd")
        CATransaction.commit()
    }
    
    func showRemote() {
        let remoteController = RemoteController()
        self.present(remoteController, animated: true, completion: nil)
    }
    
    func showPairingProcess() {
        let pairingProcess = BluetoothPairingViewController()
        self.present(pairingProcess, animated: true, completion: nil)
    }
}

