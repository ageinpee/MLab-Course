//
//  DetailVendorTableView.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 16.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension DetailVendorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vendorAccessories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customAccessoryCollectionCell", for: indexPath) as! AccessoryCustomCollectionCell
        let image = UIImage(named: vendorAccessories[indexPath.row].imageName)
        cell.accessoryImage = image
        cell.accessoryName = vendorAccessories[indexPath.row].name
        cell.accessoryDescription = vendorAccessories[indexPath.row].accessoryDescription
        
        cell.layoutSubviews()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}