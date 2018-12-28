//
//  RFPairingController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 26.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class RFPairingController1: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dottedCircle: UIImageView!
    @IBOutlet weak var remotePicker: UIPickerView!
    @IBOutlet var pairingView: UIView!
    let backgroundView = UIView()
    
    @IBOutlet weak var submitButton1: UIButton!
    
    var imageData: [UIImage] = [UIImage]()
    var remoteIDs: [String] = [String]()
    
    var selectedRemote: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.remotePicker.delegate = self
        self.remotePicker.dataSource = self
        
        imageData = [UIImage(named: "remote1.png")!, UIImage(named: "remote2.png")!, UIImage(named: "remote3.png")!]
        remoteIDs = ["Remote1", "Remote2", "Remote3"]
        selectedRemote = remoteIDs[0]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imageData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 500
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:pickerView.bounds.width - 150, height:pickerView.bounds.height - 200))
        imageView.contentMode = .scaleAspectFit
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRemote = remoteIDs[row]
        print(selectedRemote)
    }
    
    @IBAction func submit1(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "pairingTransition1") {
            if let vc = segue.destination as? RFPairingController2 {
                vc.selectedRemote = selectedRemote
            }
        }
        
    }
}
