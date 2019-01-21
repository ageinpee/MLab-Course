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
    
//    var accessoryNameView: UITextView = {
//        var textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.isScrollEnabled = false
//        textView.isEditable = false
//        textView.isUserInteractionEnabled = true
//        return textView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(accessoryImageView)
//        self.addSubview(accessoryNameView)
        
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let image = accessoryImage else { return }
//        guard let name = accessoryName else { return }
        
        accessoryImageView.image = image
//        accessoryNameView.text = name
    }
    
    func addConstraints() {
        
        accessoryImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        accessoryImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        accessoryImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        accessoryImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
//        accessoryNameView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        accessoryNameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        accessoryNameView.topAnchor.constraint(equalTo: self.accessoryImageView.bottomAnchor).isActive = true
    }
}

