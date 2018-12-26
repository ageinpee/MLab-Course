//
//  RFPairingController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 26.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class RFPairingController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dottedCircle: UIImageView!
    @IBOutlet weak var remotePicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.remotePicker.delegate = self
        self.remotePicker.dataSource = self
        
        pickerData = ["Remote1", "Remote2", "Remote3"]
        
        step1()
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
    }
    
    func step1(){
        UIView.animate(withDuration:3.0, animations: {
            self.dottedCircle.transform = CGAffineTransform(rotationAngle: CGFloat(90))
        })
        
        
    }
}
