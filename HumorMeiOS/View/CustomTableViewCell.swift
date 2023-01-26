//
//  CustomTableViewCell.swift
//  HumorMeiOS
//
//  Created by Ankush Ganesh on 24/01/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var jokeId: Int = 0 
    
    static let identifier = "CustomTableViewCell"
    
    func addToLiked() {
        likeImageView.image = UIImage(systemName: "heart.fill")
        
       
    }
}

