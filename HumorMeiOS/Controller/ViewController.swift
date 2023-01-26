//
//  ViewController.swift
//  HumorMeiOS
//
//  Created by Ankush Ganesh on 24/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var jokeAPIManager = JokerAPIManager()
    var jokesArray = [Jokes]()
    
    var selectedCategories = ["Any"]
    var likedJokes = [LikedJoke]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: CustomTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        jokeAPIManager.delegate = self
        jokeAPIManager.getJokes()
        likedJokes = LikedJoke.fetchLikedJokes()
        tableView.reloadData()
  
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        let gestureView = gesture.view as! CustomTableViewCell
        gestureView.addToLiked()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        likedJokes = LikedJoke.fetchLikedJokes()
        tableView.reloadData()
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        vc.delegate = self
        vc.selectedCategories.append(contentsOf: selectedCategories)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - JokerAPIManagerDelegate
extension ViewController: JokerAPIManagerDelegate {
    func postJokes(jokes: [Jokes]) {
        self.jokesArray = jokes
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {

    
    
        
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath)  as? CustomTableViewCell else {
            return UITableViewCell()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        
        customCell.addGestureRecognizer(tapGesture)
        customCell.titleLabel.text = jokesArray[indexPath.row].joke
        customCell.detailLabel.text = jokesArray[indexPath.row].category
        
        let alreadyLiked = likedJokes.contains { $0.joke == jokesArray[indexPath.row].joke }
            
        if alreadyLiked {
            customCell.likeImageView.image = UIImage(systemName: "heart.fill")
        } else {
            customCell.likeImageView.image = UIImage(systemName: "heart")
        }  
        return customCell
    }
}

extension ViewController: CategoriesViewControllerDelegate {
    func postCategories(_ categories: [String]) {
        // reload the table cell with new jokes.
        for eachCategory in categories {
            if !selectedCategories.contains(eachCategory){
                selectedCategories.append(eachCategory)
            }
        }
    }
}
