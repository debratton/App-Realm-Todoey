//
//  CategoriesTVC.swift
//  Todoey
//
//  Created by David E Bratton on 11/1/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoriesTVC: UITableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = categories {
            return count.count
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //Changed for SwipeCellKit
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        if let index = categories {
            cell.textLabel?.text = index[indexPath.row].name
        } else {
            cell.textLabel?.text = "No Categories Added"
        }
        //Added for SwipeCellKit
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            if let deleteCategory = categories {
//                let itemToDelete = deleteCategory[indexPath.row]
//                delete(category: itemToDelete)
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemsTVC
        if let indexPath = tableView.indexPathForSelectedRow {
            if let selectedIndex = categories {
                destinationVC.selectedCategory = selectedIndex[indexPath.row]
            }
        }
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Category: \(error.localizedDescription)")
        }
        loadCategories()
    }
    
    func delete(category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error Deleting Category: \(error.localizedDescription)")
        }
        // IT APPEARS TO CRASH WITH SWIPECELL KIT IF YOU RELOAD TABLEVIEW
        //loadCategories()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != "" {
                let newCategory = Category()
                if let newCategoryItem = textField.text {
                    newCategory.name = newCategoryItem
                    self.save(category: newCategory)
                }
            } else {
                self.presentAlert(alert: "You cannot add a blank category!")
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Search and Swipe Cell
extension CategoriesTVC: UISearchBarDelegate, SwipeTableViewCellDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if let sortedCategories = categories {
                categories = sortedCategories.filter("name CONTAINS[cd] %@", searchText).sorted(byKeyPath: "name", ascending: true)
                tableView.reloadData()
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchString = searchBar.text {
            if searchString.count == 0 {
                loadCategories()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            } else {
                if let sortedCategories = categories {
                    categories = sortedCategories.filter("name CONTAINS[cd] %@", searchText).sorted(byKeyPath: "name", ascending: true)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if let deleteCategory = self.categories {
                let itemToDelete = deleteCategory[indexPath.row]
                self.delete(category: itemToDelete)
            }
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border

        return options
    }
    
}
