//
//  RFPairingController3.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 27.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class RFPairingController3: UIViewController {
    
    @IBOutlet weak var dottedCircleImage: UIImageView!
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet var pairingView: UIView!
    let backgroundView = UIView()
    
    @IBOutlet weak var remoteImageView: UIImageView!
    
    var selectedRemote: String = ""
    
    var imageData: [UIImage] = [UIImage]()
    var remoteIDs: [String] = [String]()
    var remote: UIImage = UIImage()
    
    override func viewDidLoad() {
        
        imageData = [UIImage(named: "remote1.png")!, UIImage(named: "remote2.png")!, UIImage(named: "remote3.png")!]
        remoteIDs = ["Remote1", "Remote2", "Remote3"]
        
        if remoteIDs.contains(selectedRemote) {
            let index = remoteIDs.firstIndex(of: selectedRemote)
            remote = imageData[index!]
        }
        else
        {
            print("ERROR: remote not found")
        }
        
        remoteImageView.image = remote
    }
}
