//
//  ViewController.swift
//  HumorMeiOS
//
//  Created by Ankush Ganesh on 24/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var jokeAPIManager = JokerAPIManager()
    var jokesArray = [Jokes]()
    var selectedCategories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CustomTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomTableViewCell.identifier)
        searchTextField.delegate = self
        jokeAPIManager.delegate = self
        jokeAPIManager.getJokes()
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        let gestureView = gesture.view as! CustomTableViewCell
        let id = gestureView.jokeId!
        gestureView.addToLiked(id)
    }
    
    
    @IBAction func reloadButtonPressed(_ sender: UIBarButtonItem) {
        
        jokeAPIManager.getJokes()
        
    }
    
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        vc.delegate = self
        vc.selectedCategories.append(contentsOf: selectedCategories)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
        let searchText = searchTextField.text ?? ""
        if searchText != "" {
            searchForJokes(searchText)
        } else {
            jokeAPIManager.getJokes()
        }
        searchTextField.text = ""
    }
    
    func searchForJokes(_ searchTerm: String) {
        
        var filterdJokes = [Jokes]()
        
        for eachJoke in jokesArray {
            if eachJoke.joke.contains(searchTerm) || eachJoke.category.contains(searchTerm) {
                filterdJokes.append(eachJoke)
            }
        }
        jokesArray.removeAll()
        jokesArray = filterdJokes
        tableView.reloadData()
    }
  
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type something..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let searchText = searchTextField.text ?? ""
        searchForJokes(searchText)
        searchTextField.text = ""
    }

    
}

//MARK: - JokerAPIManagerDelegate
extension ViewController: JokerAPIManagerDelegate {
    func postError(error: String) {
        // show no jokes with tht filter
        
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
        jokeAPIManager.getJokeWithCategory(amount: 10, categories: categories)
    }
}
