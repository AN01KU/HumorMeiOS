//
//  MyLikedViewController.swift
//  HumorMeiOS
//
//  Created by Ankush Ganesh on 24/01/23.
//

import UIKit

class MyLikedViewController: UIViewController {
    
    var likedJokes = [LikedJoke]()
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CustomTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        likedJokes = LikedJoke.fetchLikedJokes()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        likedJokes = LikedJoke.fetchLikedJokes()
        tableView.reloadData()
    }

}

extension MyLikedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = LikedJoke.deleteLikedJoke(jokeId: Int(likedJokes[indexPath.row].id))
        likedJokes.remove(at: indexPath.row)
        tableView.reloadData()
    }
}

extension MyLikedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedJokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath)  as? CustomTableViewCell else {
            return UITableViewCell()
        }
        var tpJoke = likedJokes[indexPath.row]
        
        customCell.prepareCell(tpJoke.joke!, tpJoke.category!, Int(tpJoke.id))
        return customCell
    }
}
