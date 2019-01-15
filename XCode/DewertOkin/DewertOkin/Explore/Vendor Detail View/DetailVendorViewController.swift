//
//  DetailVendorView.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 13.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class DetailVendorViewController: UIViewController {
    
    var displayingVendor: Vendor!
    var vendorAccessories = [Accessory]()
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var vendorStreet: UILabel!
    @IBOutlet weak var vendorWorkingHours: UILabel!
    @IBOutlet weak var vendorTelephoneNumber: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var fontSize = 22.0
    
//    weak var delegate: DetailVendorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        initializeVendorInformation()
    }
    
    func initializeVendorInformation() {
        vendorName.text = displayingVendor.name
        vendorName.textAlignment = .center
        vendorStreet.text = displayingVendor.street
        vendorStreet.textAlignment = .center
        vendorWorkingHours.text = "Opening hours: \(displayingVendor.openingHour) - \(displayingVendor.closingHour)"
        vendorWorkingHours.textAlignment = .center
        vendorTelephoneNumber.text = displayingVendor.telephoneNumber
        vendorTelephoneNumber.textAlignment = .center
    }
    
    @IBAction func routeToVendor(_ sender: Any) {
        
    }
    
    @IBAction func cancelVendorDetail(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackground()
    }
    
}

//protocol DetailVendorViewControllerDelegate: class {
//    func removeBlurredBackground()
//}
