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
    @IBOutlet weak var vendorName: UILabel!
    
    weak var delegate: DetailVendorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        vendorName.text = displayingVendor.name
    }
    
}

protocol DetailVendorViewControllerDelegate: class {
    func removeBlurredBackground()
}
