//
//  AccessoryCustomCollectionCell.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 16.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class AccessoryCustomCollectionCell: UICollectionViewCell {
    
    var accessoryName: String?
    var accessoryImage: UIImage?
    
    var accessoryImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(accessoryImageView)
        
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let image = accessoryImage else { return }
        
        accessoryImageView.image = image
    }
    
    func addConstraints() {
        
        accessoryImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        accessoryImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        accessoryImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        accessoryImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        accessoryImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        accessoryImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
    }
}

