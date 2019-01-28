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
    @IBOutlet weak var explainationLabel: UILabel!
    
    var imageData: [Remote] = [Remote]()
    
    var selectedRemote: Remote = Remote()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.remotePicker.delegate = self
        self.remotePicker.dataSource = self
        
        imageData = [Remote(withID:"82418", withImage:UIImage(named: "remote1.png")!), // our remote
                     Remote(withID:"bedding-all", withImage:UIImage(named: "remote2.png")!),
                     Remote(withID:"84562", withImage:UIImage(named: "remote3.png")!),
                     Remote(withID:"Table-test", withImage:UIImage(named: "remote4.png")!)]
        selectedRemote = imageData[0]
        
        self.explainationLabel.alpha = 0.0
        
        layoutConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 2.0, delay: 3.0, options: [], animations: {
            self.explainationLabel.alpha = 1.0
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.remotePicker.subviews.forEach( {
            $0.isHidden = $0.frame.height < 1.0
        } )
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
            imageView.image = imageData[0].image
        case 1:
            imageView.image = imageData[1].image
        case 2:
            imageView.image = imageData[2].image
        case 3:
            imageView.image = imageData[3].image
        default:
            imageView.image = nil
            print("ERROR")
            return imageView
        }
        return imageView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRemote = imageData[row]
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
    
    
    
    
    
    func layoutConstraints() {
        remotePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: remotePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: pairingView.frame.height/1.5).isActive = true
        
        dottedCircle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: dottedCircle, attribute: .top, relatedBy: .equal, toItem: pairingView, attribute: .top, multiplier: 1, constant: 3*(pairingView.frame.height/4)).isActive = true
    }
}
