//
//  MainTVC.swift
//  Todoey
//
//  Created by David E Bratton on 10/30/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ItemsTVC: UITableViewController {
    
    let realm = try! Realm()
    var items: Results<ToDo>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let displayName = selectedCategory {
            print(displayName.name)
        }
        tableView.rowHeight = 80.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = items {
            return count.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! SwipeTableViewCell
        if let index = items {
            cell.textLabel?.text = index[indexPath.row].title
            if index[indexPath.row].done == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            print("No Items Added")
            cell.textLabel?.text = "No Items Added"
        }
        //Added for SwipeCellKit
        cell.delegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedToDo = items {
            if selectedToDo[indexPath.row].done == false {
                do {
                    try realm.write {
                        selectedToDo[indexPath.row].done = true
                    }
                } catch {
                    print("Error Saving Done: \(error.localizedDescription)")
                }
            } else {
                do {
                    try realm.write {
                        selectedToDo[indexPath.row].done = false
                    }
                } catch {
                    print("Error Saving Done: \(error.localizedDescription)")
                }
            }
        }

        tableView.deselectRow(at: indexPath, animated: true
            
        )
        loadItems()
    }
    
    // REPLACED WITH SWIPECELLKIT IN EXTENSION AT BOTTOM
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            if let deleteToDo = items {
//                let itemToDelete = deleteToDo[indexPath.row]
//                deleteToDos(itemToDelete: itemToDelete)
//            }
//        }
//    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
   
    @IBAction func addToDoBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != "" {
                let newToDo = ToDo()
                if let newToDoTitle = textField.text {
                    newToDo.title = newToDoTitle
                    newToDo.done = false
                    newToDo.dateCreated = Date()
                    self.saveToDos(newItem: newToDo)
                }
            } else {
                self.presentAlert(alert: "You cannot add a blank item!")
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveToDos(newItem: ToDo) {
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    currentCategory.todos.append(newItem)
                }
            } catch {
                print("Error Saving Data: \(error.localizedDescription)")
            }
        }
        loadItems()
    }
    
    func deleteToDos(itemToDelete: ToDo) {
        do {
            try realm.write {
                realm.delete(itemToDelete)
            }
        } catch {
            print("Error Deleting ToDo: \(error.localizedDescription)")
        }
        //loadItems()
    }

    func loadItems() {
        //items = selectedCategory?.todos.sorted(byKeyPath: "title", ascending: true)
        if let loadValues = selectedCategory {
            items = loadValues.todos.sorted(byKeyPath: "title", ascending: true)
        }
        
        tableView.reloadData()
    }
}


extension ItemsTVC: UISearchBarDelegate, SwipeTableViewCellDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if let sortedItems = items {
                items = sortedItems.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
                tableView.reloadData()
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchString = searchBar.text {
            if searchString.count == 0 {
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            } else {
                if let sortedItems = items {
                    items = sortedItems.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if let deleteToDo = self.items {
                let itemToDelete = deleteToDo[indexPath.row]
                self.deleteToDos(itemToDelete: itemToDelete)
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
