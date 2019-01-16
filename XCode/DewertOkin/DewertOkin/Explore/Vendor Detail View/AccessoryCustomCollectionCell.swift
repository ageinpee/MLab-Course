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
    var accessoryDescription: String?
    
    var accessoryImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var accessoryNameView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    var accessoryDescriptionView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(accessoryImageView)
        self.addSubview(accessoryNameView)
        self.addSubview(accessoryDescriptionView)
        
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let image = accessoryImage else { return }
        guard let name = accessoryName else { return }
        guard let status = accessoryDescription else { return }
        
        accessoryImageView.image = image
        accessoryNameView.text = name
        accessoryDescriptionView.text = status
    }
    
    func addConstraints() {
        
        accessoryImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        accessoryImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        accessoryImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        accessoryImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        accessoryImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        accessoryNameView.leftAnchor.constraint(equalTo: self.accessoryImageView.rightAnchor).isActive = true
        //accessoryNameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        accessoryNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        accessoryDescriptionView.topAnchor.constraint(equalTo: self.accessoryNameView.bottomAnchor).isActive = true
        accessoryDescriptionView.leftAnchor.constraint(equalTo: self.accessoryImageView.rightAnchor).isActive = true
        //accessoryDescriptionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

