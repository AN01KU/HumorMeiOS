//
//  CategoriesCollectionViewCell.swift
//  HumorMeiOS
//
//  Created by Ankush Ganesh on 25/01/23.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func prepareShadow() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0

        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
    }
}
