//
//  CategoriesViewController.swift
//  HumorMeiOS
//
//  Created by Ankush Ganesh on 25/01/23.
//

import UIKit

protocol CategoriesViewControllerDelegate: NSObject {
    func postCategories(_ categories: [String])
}

class CategoriesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let categories = ["Any", "Misc", "Programming", "Dark", "Pun", "Spooky", "Christmas"]
    
    static let identifier = "CategoriesViewController"
    weak var delegate: CategoriesViewControllerDelegate!
    
    var selectedCategories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print(selectedCategories)
        delegate?.postCategories(selectedCategories)
        navigationController?.popViewController(animated: true)
    }
    
}

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCategories.contains(categories[indexPath.row]) {
            selectedCategories = selectedCategories.filter { $0 != categories[indexPath.row] }
            collectionView.reloadItems(at: [indexPath])
        } else {
            selectedCategories.append(categories[indexPath.row])
            collectionView.reloadItems(at: [indexPath])
        }
    }

}

//MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 150, height: 100)
        }
}

//MARK: - UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.categoryLabel.text = categories[indexPath.row]
        if !selectedCategories.contains(categories[indexPath.row]) {
            cell.imageView.image = UIImage(systemName: "pencil.circle")
        } else {
            cell.imageView.image = UIImage(systemName: "pencil.circle.fill")
        }
        return cell
    }
}
