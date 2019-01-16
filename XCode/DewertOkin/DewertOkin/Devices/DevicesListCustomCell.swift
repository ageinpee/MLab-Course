//
//  DevicesListCustomCell.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 04.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class DevicesListCustomCell: UITableViewCell {
    
    var deviceImage: UIImage?
    var deviceName: String?
    var deviceStatus: String?
    
    var deviceImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var deviceNameView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 20.0)
        return textView
    }()
    
    var deviceStatusView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 20.0)
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Adding all image views to the cell
        self.addSubview(deviceImageView)
        self.addSubview(deviceNameView)
        self.addSubview(deviceStatusView)
        
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let image = deviceImage else { return }
        guard let name = deviceName else { return }
        guard let status = deviceStatus else { return }
        
        deviceImageView.image = image
        deviceNameView.text = name
        deviceStatusView.text = status
    }
    
    func addConstraints() {
        deviceImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        deviceImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        deviceImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        deviceImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        deviceImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        deviceNameView.leftAnchor.constraint(equalTo: self.deviceImageView.rightAnchor).isActive = true
        deviceNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        deviceNameView.bottomAnchor.constraint(equalTo: self.deviceStatusView.topAnchor).isActive = true
        
        deviceStatusView.topAnchor.constraint(equalTo: self.deviceNameView.bottomAnchor).isActive = true
        deviceStatusView.leftAnchor.constraint(equalTo: self.deviceImageView.rightAnchor).isActive = true
        deviceStatusView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
