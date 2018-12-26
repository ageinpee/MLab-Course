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
    
    //var pickerData: [String] = [String]()
    var imageData: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.remotePicker.delegate = self
        self.remotePicker.dataSource = self
        
        //pickerData = ["Remote1", "Remote2", "Remote3"]
        imageData = [UIImage(named: "remote1.png")!, UIImage(named: "remote2.png")!, UIImage(named: "remote3.png")!]
        
        //step1()
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imageData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 500
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:pickerView.bounds.width - 150, height:400))
        imageView.contentMode = .scaleAspectFit
        
        //let myView = UIImageView(frame: CGRect(x:0, y:0, width:50, height:50))
        
        switch row {
        case 0:
            imageView.image = imageData[0]
        case 1:
            imageView.image = imageData[1]
        case 2:
            imageView.image = imageData[2]
        default:
            imageView.image = nil
            print("XXX")
            return imageView
        }
        return imageView
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // do something with selected row
    }
    
}
