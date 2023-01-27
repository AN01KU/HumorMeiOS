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
        } else {
            likeImageView.image = UIImage(systemName: "heart")
        }
    }
    
    func addToLiked(_ jokeId: Int) {
        if checkIfAlreadyLiked(jokeId) == false {
            likeImageView.image = UIImage(systemName: "heart.fill")
            let _ = LikedJoke.addLikedJoke(joke: titleLabel.text!, category: detailLabel.text! , id: jokeId)
        }
    }


    func checkIfAlreadyLiked(_ jokeId: Int) -> Bool {
        likedJokes = LikedJoke.fetchLikedJokes()
        let alreadyLiked = likedJokes?.contains { $0.id == Int64(jokeId) }
        if alreadyLiked! {
            return true
        }
        return false
    }    
}

