//
//  ViewController.swift
//  HumorMeiOS
//
//  Created by Ankush Ganesh on 24/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UISearchBar!
    

    var refreshControl = UIRefreshControl()
    var jokeAPIManager = JokerAPIManager()
    var jokesArray = [Jokes]()
    var selectedCategories: [String] = []
    var searchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CustomTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomTableViewCell.identifier)
        jokeAPIManager.delegate = self
        jokeAPIManager.getJokes()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        selectedCategories.append("Any")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func refresh(send: UIRefreshControl) {
        DispatchQueue.main.async {
            self.searchText.text = ""
            self.jokeAPIManager.getJokes()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        let gestureView = gesture.view as! CustomTableViewCell
        let jokeText = gestureView.titleLabel.text
        gestureView.addToLiked(jokeText!)
    }    
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        vc.delegate = self
        vc.selectedCategories.append(contentsOf: selectedCategories)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       searchQuery = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchQuery != "" {
            jokeAPIManager.getJokeWithFilter(categories: selectedCategories, searchQuery: searchQuery)
            tableView.reloadData()
        } else {
            jokeAPIManager.getJokes()
            tableView.reloadData()
        }
    }
    

}

//MARK: - JokerAPIManagerDelegate
extension ViewController: JokerAPIManagerDelegate {
    func postError(error: String) {
//        print(error)
        jokesArray.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func postJokes(jokes: [Jokes]) {
        jokesArray = jokes
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
        let tpJoke = jokesArray[indexPath.row]
        customCell.prepareCell(tpJoke.joke, tpJoke.category, tpJoke.id)
        return customCell
    }
}

extension ViewController: CategoriesViewControllerDelegate {
    func postCategories(_ categories: [String]) {
        selectedCategories = categories
        jokeAPIManager.getJokeWithFilter(categories: categories, searchQuery: searchQuery)
    }
}

