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
    var joke: Jokes?
    var jokeId: Int?
    var likedJokes: [LikedJoke]?
    
    static let identifier = "CustomTableViewCell"
    
    func prepareCell(_ jokeText: String,_ jokeCategory: String,_ id: Int) {
        jokeId = id
        titleLabel.text = jokeText
        detailLabel.text = jokeCategory
        if checkIfAlreadyLiked(jokeId!) {
            likeImageView.image = UIImage(systemName: "heart.fill")
        }
    }
    
    func addToLiked(_ id: Int) {
        if checkIfAlreadyLiked(id) == false {
            likeImageView.image = UIImage(systemName: "heart.fill")
            let _ = LikedJoke.addLikedJoke(joke: titleLabel.text!, category: detailLabel.text!, id: jokeId!)
        }
    }


    func checkIfAlreadyLiked(_ id: Int) -> Bool {
        likedJokes = LikedJoke.fetchLikedJokes()
        let alreadyLiked = likedJokes?.contains { $0.id == id }
        if alreadyLiked! {
            return true
        }
        return false
    }
    
}

