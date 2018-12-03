//
//  OldRemoteViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 03.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit

class OldRemoteViewController: UIViewController {

    @IBOutlet weak var flashLightButton: UIButton!
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownDetected))
//        swipeDown.direction = .down
//        flashLightButton.addGestureRecognizer(swipeDown)

        // Do any additional setup after loading the view.
    }
    
//    @objc
//    private func swipeDownDetected() {
//        print("Swipe Down")
//        self.dismiss(animated: true)
//    }
    
    //----------------------------------------
    //----- generic remote design buttons ----
    
    @IBAction func headUpBtn(_ sender: Any) {
        
    }
    
    @IBAction func headDownBtn(_ sender: Any) {
        print("asdadasdasdadsadasd is an overload!")
        
    }
    
    @IBAction func FootUpBtn(_ sender: Any) {
    }
    
    @IBAction func FootDownBtn(_ sender: Any) {
    }
    
    
    @IBAction func RestPosBtn(_ sender: Any) {
    }
    
    @IBAction func FlatPosBtn(_ sender: Any) {
    }
    
    @IBAction func M1Btn(_ sender: Any) {
    }
    
    @IBAction func M2Btn(_ sender: Any) {
    }
    
    @IBAction func SaveBtn(_ sender: Any) {
    }
    
    
    @IBAction func UblBtn(_ sender: Any) {
    }
    
    @IBAction func TourchBtn(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
