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
        likedJokes = LikedJoke.fetchLikedJokes()
        let alreadyLiked = likedJokes?.contains { $0.id == jokeId! }
        if alreadyLiked! {
            likeImageView.image = UIImage(systemName: "heart.fill")
        }
    }
    
    func addToLiked() {
        let _ = LikedJoke.addLikedJoke(joke: titleLabel.text!, category: detailLabel.text!, id: jokeId!)
    }
    
    func deleteFromLiked() {
        let _ = LikedJoke.deleteLikedJoke(jokeId: jokeId!)
    }
}

